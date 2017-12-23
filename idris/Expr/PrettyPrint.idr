module Expr.PrettyPrint

import Expr

export total 
pretty : Expr -> String 
pretty (Free var)  = var
pretty (Bound n v) = show n
pretty (ELam lam)  = "(\x3BB " ++ pretty lam ++ ")"
pretty (EApp s t)  = 
  case t of
    EApp _ _ => pretty s ++ " (" 
             ++ pretty t ++ ")"
    _        => pretty s ++ " "  
             ++ pretty t
