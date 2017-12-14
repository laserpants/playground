module Main

import Expr
import Term
import Tests.Term

testReduce : String -> Expr -> Bool
testReduce input exp = map (reduce . toExpr) (parseTerm input) == Right exp
  where
    fromRight : Either a b -> b
    fromRight (Right r) = r

testSubst : Nat -> Expr -> Expr -> Expr -> Bool
testSubst i term e e1 = substitute i term e == e1

main : IO ()
main = do 
  -- tests
  printLn $ testReduce "(~x.x) v" (Free "v") 
                        -- (\x.x)v       ==> v
  printLn $ testReduce "(~x.~y.x) v" (ELam (Free "v")) 
                        -- (\x.\y.x)v    ==> \y.v
  printLn $ testReduce "(~x.~y.~z.x) v" (ELam (ELam (Free "v"))) 
                        -- (\x.\y.\z.x)v ==> \y.\z.v
  printLn $ testReduce "(~x.~y.~z.y) v" (ELam (ELam (Bound 1))) 
                        -- (\x.\y.\z.y)v ==> \y.\z.y
  printLn $ testReduce "(~x.~y.~z.z) v" (ELam (ELam (Bound 0))) 
                        -- (\x.\y.\z.z)v ==> \y.\z.z
  printLn $ testReduce "(~x.~x.~x.x) y" (ELam (ELam (Bound 0))) 
                        -- (\x.\x.\x.x)y ==> \x.\x.x
  printLn $ testReduce "(~x.v) v" (Free "v") 
                        -- (\x.v)v       ==> v
  printLn $ testReduce "(u v)" (EApp (Free "u") (Free "v"))
                        -- u v           ==> u v
  printLn $ testSubst 0 (ELam (ELam (Bound 2))) (Free "v") (ELam (ELam (Free "v")))
                        -- (\x.\x.#2)[ 0 := v ] ==> \x.\x.v
  printLn $ testSubst 0 (ELam (ELam (Bound 3))) (Free "v") (ELam (ELam (Bound 3)))
                        -- (\x.\x.#3)[ 0 := v ] ==> \x.\x.#3
  printLn $ testSubst 0 (ELam (ELam (Bound 3))) (Free "v") (ELam (ELam (Bound 3)))
                        -- (\x.\x.#1)[ 0 := v ] ==> \x.\x.#3

