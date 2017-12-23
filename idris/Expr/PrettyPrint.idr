module Expr.PrettyPrint

import Expr

export total 
pretty : Expr -> String 
pretty (Free var) = var
pretty (Bound n)  = show n
pretty (ELam t _) = "(\x3BB " ++ pretty t ++ ")"
pretty (EApp s t) = 
  case t of
    EApp _ _ => pretty s ++ " (" 
             ++ pretty t ++ ")"
    _        => pretty s ++ " "  
             ++ pretty t
