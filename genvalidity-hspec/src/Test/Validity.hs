{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE ScopedTypeVariables   #-}
module Test.Validity
    ( module Data.GenValidity
    , Proxy(Proxy)

      -- * Tests for Arbitrary instances involving Validity
    , arbitrarySpec
    , arbitraryGeneratesOnlyValid
    , shrinkProducesOnlyValids

      -- * Tests for GenValidity instances
    , genValiditySpec
    , genValidityValidGeneratesValid
    , genGeneratesValid
    , genValidityInvalidGeneratesInvalid
    , genGeneratesInvalid

      -- * Tests for RelativeValidity instances
    , relativeValiditySpec
    , relativeValidityImpliesValidA
    , relativeValidityImpliesValidB

      -- * Tests for GenRelativeValidity instances
    , genRelativeValiditySpec
    , genRelativeValidityValidGeneratesValid
    , genRelativeValidityInvalidGeneratesInvalid


      -- * Standard tests involving functions

      -- ** Standard tests involving validity
    , producesValidsOnGen
    , producesValidsOnValids
    , producesValid
    , producesValidsOnArbitrary
    , producesValidsOnGens2
    , producesValidsOnValids2
    , producesValid2
    , producesValidsOnArbitrary2
    , producesValidsOnGens3
    , producesValidsOnValids3
    , producesValid3
    , producesValidsOnArbitrary3

      -- ** Standard tests involving functions that can fail
    , CanFail(..)

    , succeedsOnGen
    , succeedsOnValid
    , succeeds
    , succeedsOnArbitrary

    , succeedsOnGens2
    , succeedsOnValids2
    , succeeds2
    , succeedsOnArbitrary2

    , failsOnGen
    , failsOnInvalid

    , failsOnGens2
    , failsOnInvalid2

    , validIfSucceedsOnGen
    , validIfSucceedsOnValid
    , validIfSucceedsOnArbitrary
    , validIfSucceeds

    , validIfSucceedsOnGens2
    , validIfSucceedsOnValids2
    , validIfSucceeds2
    , validIfSucceedsOnArbitrary2

      -- ** Standard tests involving equivalence of functions
    , equivalentOnGen
    , equivalentOnValid
    , equivalent
    , equivalentOnGens2
    , equivalentOnValids2
    , equivalent2
    , equivalentWhenFirstSucceedsOnGen
    , equivalentWhenFirstSucceedsOnValid
    , equivalentWhenFirstSucceeds
    , equivalentWhenFirstSucceedsOnGens2
    , equivalentWhenFirstSucceedsOnValids2
    , equivalentWhenFirstSucceeds2
    , equivalentWhenSecondSucceedsOnGen
    , equivalentWhenSecondSucceedsOnValid
    , equivalentWhenSecondSucceeds
    , equivalentWhenSecondSucceedsOnGens2
    , equivalentWhenSecondSucceedsOnValids2
    , equivalentWhenSecondSucceeds2
    , equivalentWhenSucceedOnGen
    , equivalentWhenSucceedOnValid
    , equivalentWhenSucceed
    , equivalentWhenSucceedOnGens2
    , equivalentWhenSucceedOnValids2
    , equivalentWhenSucceed2

      -- ** Standard tests involving inverse functions
    , inverseFunctionsOnGen
    , inverseFunctionsOnValid
    , inverseFunctions
    , inverseFunctionsOnArbitrary
    , inverseFunctionsIfFirstSucceedsOnGen
    , inverseFunctionsIfFirstSucceedsOnValid
    , inverseFunctionsIfFirstSucceeds
    , inverseFunctionsIfFirstSucceedsOnArbitrary
    , inverseFunctionsIfSecondSucceedsOnGen
    , inverseFunctionsIfSecondSucceedsOnValid
    , inverseFunctionsIfSecondSucceeds
    , inverseFunctionsIfSecondSucceedsOnArbitrary
    , inverseFunctionsIfSucceedOnGen
    , inverseFunctionsIfSucceedOnValid
    , inverseFunctionsIfSucceed
    , inverseFunctionsIfSucceedOnArbitrary

      -- ** Properties involving idempotence
    , idempotentOnGen
    , idempotentOnValid
    , idempotent
    , idempotentOnArbitrary


      -- * Properties of relations

      -- ** Reflexivity
    , reflexiveOnElem
    , reflexivityOnGen
    , reflexivityOnValid
    , reflexivity
    , reflexivityOnArbitrary

      -- ** Transitivity
    , transitiveOnElems
    , transitivityOnGens
    , transitivityOnValid
    , transitivity
    , transitivityOnArbitrary

      -- ** Antisymmetry
    , antisymmetricOnElemsWithEquality
    , antisymmetryOnGensWithEquality
    , antisymmetryOnGensEq
    , antisymmetryOnValid
    , antisymmetry
    , antisymmetryOnArbitrary

      -- ** Symmetry
    , symmetricOnElems
    , symmetryOnGens
    , symmetryOnValid
    , symmetry
    , symmetryOnArbitrary


      -- * Properties of operations

      -- ** Identity element

      -- *** Left Identity
    , leftIdentityOnElemWithEquality
    , leftIdentityOnGenWithEquality
    , leftIdentityOnGen
    , leftIdentityOnValid
    , leftIdentity

      -- *** Right Identity
    , rightIdentityOnElemWithEquality
    , rightIdentityOnGenWithEquality
    , rightIdentityOnGen
    , rightIdentityOnValid
    , rightIdentity

      -- *** Identity
    , identityOnGen
    , identityOnValid
    , identity

      -- ** Associativity
    , associativeOnGens
    , associativeOnValids
    , associative
    , associativeOnArbitrary

      -- ** Commutativity
    , commutativeOnGens
    , commutativeOnValids
    , commutative
    , commutativeOnArbitrary


      -- * Eq properties
    , eqSpec

      -- * Ord properties
    , ordSpec
    ) where

import           Data.GenValidity
import           Data.Data

import           Test.Validity.Arbitrary
import           Test.Validity.Eq
import           Test.Validity.Functions
import           Test.Validity.GenRelativeValidity
import           Test.Validity.GenValidity
import           Test.Validity.Operations
import           Test.Validity.Ord
import           Test.Validity.Relations
import           Test.Validity.RelativeValidity
import           Test.Validity.Types
