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

testShowExpr : String -> String -> IO ()
testShowExpr input match =
  if lhs == Right match
    then putStrLn "\x2714 Ok"
    else putStrLn ("Error: " ++ input ++ " /= " ++ match)
where
  lhs : Either String String
  lhs = show . toExpr <$> parse term input

fromRight : Either a b -> b
fromRight (Right r) = r

expr_ : String -> Expr 
expr_ = fromRight . map toExpr . parseTerm 

testExprEq : Expr -> Expr -> IO ()
testExprEq x y =
  if x == y
    then putStrLn "\x2714 Ok"
    else putStrLn ("Error: " ++ show x ++ " /= " ++ show y)

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
  --
  testShowExpr "~x.x" "(λ 0)"
  testShowExpr "~y.y" "(λ 0)"
  testShowExpr "~x.~y.y x" "(λ (λ 0 1))"
  testShowExpr "a b" "a b"
  testShowExpr "(a b) c" "a b c"
  testShowExpr "a (b c)" "a (b c)"
  testShowExpr "a b c d" "a b c d"
  testShowExpr "((a b) c) d" "a b c d"
  testShowExpr "a (b (c d))" "a (b (c d))"
  testShowExpr "a (b c) d" "a (b c) d"
  testShowExpr "a (b c d)" "a (b c d)"
  --
  testExprEq (expr_ "~f.~x.f x") (reduce (reduce (reduce (expr_ "(~n.~f.~x.f (n f x)) (~f.~x.x)"))))

