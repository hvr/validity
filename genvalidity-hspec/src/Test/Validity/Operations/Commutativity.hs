{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE ScopedTypeVariables   #-}
module Test.Validity.Operations.Commutativity
    ( -- ** Commutativity
      commutativeOnGens
    , commutativeOnValids
    , commutative
    , commutativeOnArbitrary
    ) where

import           Data.GenValidity

import           Test.Hspec
import           Test.QuickCheck

commutativeOnGens
    :: (Show a, Eq a)
    => (a -> a -> a)
    -> Gen (a, a)
    -> Property
commutativeOnGens op gen =
    forAll gen $ \(a, b) ->
        (a `op` b) `shouldBe` (b `op` a)

commutativeOnValids
    :: (Show a, Eq a, GenValidity a)
    => (a -> a -> a)
    -> Property
commutativeOnValids op
    = commutativeOnGens op genValid

commutative
    :: (Show a, Eq a, GenValidity a)
    => (a -> a -> a)
    -> Property
commutative op
    = commutativeOnGens op genUnchecked

commutativeOnArbitrary
    :: (Show a, Eq a, Arbitrary a)
    => (a -> a -> a)
    -> Property
commutativeOnArbitrary op
    = commutativeOnGens op arbitrary
