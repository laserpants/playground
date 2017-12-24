module Main

import Effect.StdIO
import Effects
import Expr
import Readline
import Term
import Tests.Term
import Term.PrettyPrint

--church_0 : Expr 
--church_0 = expr_ "~f.~x.x"
--
--church_1 : Expr 
--church_1 = expr_ "~f.~x.f x"
--
--church_2 : Expr 
--church_2 = expr_ "~f.~x.f (f x)"
--
--church_3 : Expr 
--church_3 = expr_ "~f.~x.f (f (f x))"

run : Expr -> IO ()
run expr = putStrLn (pretty (toTerm r)) where 
  r = reduce expr

main : IO ()
main = do
  str <- readline "$ "
  case parseTerm str of
    Left e => print e
    Right term => run (fromTerm term)
  -- run hello
  -- tests
