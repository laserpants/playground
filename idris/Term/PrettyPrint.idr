module Term.PrettyPrint

import Term

mutual
  lam : Term -> String
  lam (Lam x t) = "\x03BB" ++ x ++ "." ++ lam t
  lam term = app term

  app : Term -> String
  app (App t u) = app t ++ " " ++ pretty u
  app term = pretty term

  export pretty : Term -> String
  pretty term = 
    case term of
      Lam _ _ => "(" ++ lam term ++ ")"
      App _ _ => "(" ++ app term ++ ")"
      Var var => var
