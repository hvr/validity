{-|

    @GenValidity@ exists to make tests involving @Validity@ types easier and speed
    up the generation of data for them.

    Let's use the example from @Data.Validity@ again: A datatype that represents
    primes.
    To implement tests for this datatype, we would have to be able to generate
    both primes and non-primes. We could do this with
    @(Prime <$> arbitrary) `suchThat` isValid@
    but this is tedious and inefficient.

    The @GenValidity@ type class allows you to specify how to (efficiently)
    generate data of the given type to allow for easier and quicker testing.
    Just implementing @genUnchecked@ already gives you access to @genValid@ and
    @genInvalid@ but writing custom implementations of these functions may speed
    up the generation of data.

    For example, to generate primes, we don't have to consider even numbers other
    than 2. A more efficient implementation could then look as follows:

    > instance GenValidity Prime where
    >     genUnchecked = Prime <$> arbitrary
    >     genValid = Prime <$>
    >        (oneof
    >          [ pure 2
    >          , ((\y -> 2 * abs y + 1) <$> arbitrary) `suchThat` isPrime)
    >          ])


    Typical examples of tests involving validity could look as follows:

    > it "succeeds when given valid input" $ do
    >     forAll genValid $ \input ->
    >         myFunction input `shouldSatisfy` isRight

    > it "produces valid output when it succeeds" $ do
    >     forAll genUnchecked $ \input ->
    >         case myFunction input of
    >             Nothing -> return () -- Can happen
    >             Just output -> output `shouldSatisfy` isValid
    -}

module Data.GenValidity
    ( module Data.Validity
    , module Data.GenValidity
    ) where

import           Data.Validity

import           Test.QuickCheck

import           Control.Monad   (forM)

-- | A class of types for which @Validity@-related values can be generated.
--
-- If you also write @Arbitrary@ instances for @GenValidity@ types, it may be
-- best to simply write @arbitrary = genValid@.
class Validity a => GenValidity a where
    -- | Generate a truly arbitrary datum, this should cover all possible
    -- values in the type
    genUnchecked :: Gen a

    -- | Generate a valid datum, this should cover all possible valid values in
    -- the type
    --
    -- The default implementation is as follows:
    --
    -- >  genValid = genUnchecked `suchThat` isValid
    --
    -- To speed up testing, it may be a good idea to implement this yourself.
    -- If you do, make sure that it is possible to generate all possible valid
    -- data, otherwise your testing may not cover all cases.
    genValid :: Gen a
    genValid = genUnchecked `suchThat` isValid

    -- | Generate an invalid datum, this should cover all possible invalid
    -- values
    --
    -- > genInvalid = genUnchecked `suchThat` (not . isValid)
    --
    -- To speed up testing, it may be a good idea to implement this yourself.
    -- If you do, make sure that it is possible to generate all possible
    -- invalid data, otherwise your testing may not cover all cases.
    genInvalid :: Gen a
    genInvalid = genUnchecked `suchThat` (not . isValid)
    {-# MINIMAL genUnchecked #-}

instance (GenValidity a, GenValidity b) => GenValidity (a, b) where
    genUnchecked = sized $ \n -> do
        (r, s) <- genSplit n
        a <- resize r genUnchecked
        b <- resize s genUnchecked
        return (a, b)

    genValid = sized $ \n -> do
        (r, s) <- genSplit n
        a <- resize r genValid
        b <- resize s genValid
        return (a, b)

    genInvalid = sized $ \n -> do
        (r, s) <- genSplit n
        oneof
            [ do
                a <- resize r genUnchecked
                b <- resize s genInvalid
                return (a, b)
            , do
                a <- resize r genInvalid
                b <- resize s genUnchecked
                return (a, b)
            ]

instance (GenValidity a, GenValidity b, GenValidity c) => GenValidity (a, b, c) where
    genUnchecked = sized $ \n -> do
        (r, s, t) <- genSplit3 n
        a <- resize r genUnchecked
        b <- resize s genUnchecked
        c <- resize t genUnchecked
        return (a, b, c)

    genValid = sized $ \n -> do
        (r, s, t) <- genSplit3 n
        a <- resize r genValid
        b <- resize s genValid
        c <- resize t genValid
        return (a, b, c)

    genInvalid = sized $ \n -> do
        (r, s, t) <- genSplit3 n
        oneof
            [ do
                a <- resize r genInvalid
                b <- resize s genUnchecked
                c <- resize t genUnchecked
                return (a, b, c)
            , do
                a <- resize r genUnchecked
                b <- resize s genInvalid
                c <- resize t genUnchecked
                return (a, b, c)
            , do
                a <- resize r genUnchecked
                b <- resize s genUnchecked
                c <- resize t genInvalid
                return (a, b, c)
            ]

instance GenValidity a => GenValidity (Maybe a) where
    genUnchecked = oneof [pure Nothing, Just <$> genUnchecked]
    genValid     = oneof [pure Nothing, Just <$> genValid]
    genInvalid   = Just <$> genInvalid


-- | If we can generate values of a certain type, we can also generate lists of
-- them.
-- This instance ensures that @genValid@ generates only lists of valid data and
-- that @genInvalid@ generates lists of data such that there is at least one
-- value in there that does not satisfy @isValid@, the rest is unchecked.
instance GenValidity a => GenValidity [a] where
    genUnchecked = genListOf genUnchecked

    genValid     = genListOf genValid

    -- | At least one invalid value in the list, the rest could be either.
    genInvalid   = sized $ \n -> do
        (x, y, z) <- genSplit3 n
        before <- resize x $ genListOf genUnchecked
        middle <- resize y genInvalid
        after  <- resize z $ genListOf genUnchecked
        return $ before ++ [middle] ++ after

upTo :: Int -> Gen Int
upTo n
    | n <= 0 = pure 0
    | otherwise = elements [0 .. n]

genSplit :: Int -> Gen (Int, Int)
genSplit n
    | n < 0     = pure (0, 0)
    | otherwise = elements [ (i, n - i) | i <- [0..n] ]

genSplit3 :: Int -> Gen (Int, Int, Int)
genSplit3 n
    | n < 0     = pure (0, 0, 0)
    | otherwise = do
    (a, z) <- genSplit n
    (b, c) <- genSplit z
    return (a, b, c)

arbPartition :: Int -> Gen [Int]
arbPartition k
    | k <= 0 = pure []
    | otherwise = do
    first <- elements [1..k]
    rest <- arbPartition $ k - first
    return $ first : rest

-- | A version of @listOf@ that takes size into account more accurately.
genListOf :: Gen a -> Gen [a]
genListOf func = sized $ \n -> do
    size <- upTo n
    pars <- arbPartition size
    forM pars $ \i -> resize i func

