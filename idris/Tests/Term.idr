module Tests.Term

import Lightyear
import Lightyear.Strings
import Expr
import Term

testToExpr : String -> Expr -> IO ()
testToExpr input expr = 
  if Right expr == rhs
    then putStrLn "\x2714 Ok"
    else putStrLn ("Error: " ++ show rhs ++ " /= " ++ show expr)
where
  rhs : Either String Expr
  rhs = map toExpr (parse term input) 

testParseTerm : String -> String -> IO ()
testParseTerm input match =
  if Right match == rhs
    then putStrLn "\x2714 Ok"
    else putStrLn ("Error: " ++ show rhs ++ " /= " ++ match)
where
  rhs : Either String String
  rhs = map show (parse term input)

export tests : IO ()
tests = do
  --
  testParseTerm "x x" "(x y)"
  testParseTerm "~x.x" "~x.x"
  testParseTerm "~x.(x x)" "~x.(x x)"
  testParseTerm "(x x)(x x)" "((x x) (x x))"
  testParseTerm "(((x y) z) a)" "(((x y) z) a)"
  testParseTerm "(x (y (z a)))" "(x (y (z a)))"
  testParseTerm "z" "z"
  testParseTerm "(a b) z" "((a b) z)"
  testParseTerm "~z.a b z" "~z.((a b) z)"
  testParseTerm "~y.~z.a b z" "~y.~z.((a b) z)"
  testParseTerm "(~x.x)" "~x.x"
  testParseTerm "wat dat" "(wat dat)"
  --
  testToExpr "~x.x" (ELam (Bound 0))
  testToExpr "~y.y" (ELam (Bound 0))
  testToExpr "~x.x y" (ELam (EApp (Bound 0) (Free "y")))
  testToExpr "~x.~y.y x" (ELam (ELam (EApp (Bound 0) (Bound 1))))
  testToExpr "a b" (EApp (Free "a") (Free "b"))
  testToExpr "(~x.(~x.(~x.x x) x) x)" (ELam (EApp (ELam (EApp (ELam (EApp (Bound 0) (Bound 0))) (Bound 0))) (Bound 0)))
  testToExpr "(~x.(~y.x y) x)" (ELam (EApp (ELam (EApp (Bound 1) (Bound 0))) (Bound 0)))
