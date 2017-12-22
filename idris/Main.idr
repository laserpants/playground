module Main

import Expr
import Expr.PrettyPrint
import Term
import Term.PrettyPrint
import Tests.Term

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

main : IO ()
main = pure () -- tests
