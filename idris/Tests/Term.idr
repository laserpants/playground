module Tests.Term

import Lightyear
import Lightyear.Strings
import Term

testParseTerm : String -> String -> IO ()
testParseTerm input match =
  if Right match == rhs
    then putStrLn "\x2714 Ok"
    else putStrLn ("Error: " ++ show rhs ++ " /= " ++ match)
where
  rhs : Either String String
  rhs = map show (parse term input)

export
tests : IO ()
tests = do
  testParseTerm "x x" "(x x)"
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
