module Main

import Expr
import Term
import Tests.Term

fromRight : Either a b -> b
fromRight (Right r) = r

testReduce : String -> Expr -> Bool
testReduce input exp = map (reduce . toExpr) (parseTerm input) == Right exp

testSubst : Nat -> Expr -> Expr -> Expr -> Bool
testSubst i term e e1 = substitute i term e == e1

expr_ : String -> Expr 
expr_ = fromRight . map toExpr . parseTerm 

succ : Expr 
succ = expr_ "~n.~f.~x.f (n f x)"

church_0 : Expr 
church_0 = expr_ "~f.~x.x"

church_1 : Expr 
church_1 = expr_ "~f.~x.f x"

church_2 : Expr 
church_2 = expr_ "~f.~x.f (f x)"

church_3 : Expr 
church_3 = expr_ "~f.~x.f (f (f x))"

main : IO ()
main = do 
  --
  tests
  --
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

  printLn (expr_ "(~n.~f.~x.f (n f x)) (~f.~x.x)")
  -- (λ (λ (λ 1 (2 1 0)))) (λ (λ 0))

  printLn (reduce (expr_ "(~n.~f.~x.f (n f x)) (~f.~x.x)"))
  -- (λ (λ 1 ((λ (λ 0)) 1 0)))

  printLn (reduce (reduce (expr_ "(~n.~f.~x.f (n f x)) (~f.~x.x)")))
  -- (λ (λ 1 ((λ 0) 0)))

  printLn (reduce (reduce (reduce (expr_ "(~n.~f.~x.f (n f x)) (~f.~x.x)"))))
  -- (λ (λ 1 0))

  printLn (reduce (reduce (reduce (reduce (expr_ "(~n.~f.~x.f (n f x)) (~f.~x.x)")))))
  -- (λ (λ 1 0))

