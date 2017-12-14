module Expr

import Term 

||| De Bruijn-indexed intermediate lambda term data type representation.
||| 
||| In this scheme, the two alpha equivalent terms ~x.x and ~y.y are both 
||| represented in canonical form, as `ELam (Bound 0)`.
public export data Expr = 
  ||| Bound variable (depth indexed)
  Bound Nat |
  ||| Free variable
  Free String |   
  ||| Application
  EApp Expr Expr |
  ||| Lambda abstraction
  ELam Expr

export Eq Expr where
  (Bound a)  == (Bound b)  = a == b
  (Free a)   == (Free b)   = a == b
  (EApp t v) == (EApp u w) = t == u && v == w
  (ELam t)   == (ELam u)   = t == u
  _          == _          = False

export Show Expr where
  show (ELam lam) = "\x3BB " ++ show lam
  show (Free var) = var
  show (Bound  n) = show n
  show (EApp t u) = "(" ++ show t ++ " " 
                        ++ show u ++ ")"

||| Translate a `Term` value to canonical `Expr` representation form, based on
||| so called De Bruijn indexing.
||| @t the input term
export total toExpr : (t : Term) -> Expr
toExpr = toE [] where
  toE : List String -> Term -> Expr
  toE ctx (Term.Lam x t) = ELam (toE new_ctx t) where new_ctx = x :: ctx
  toE ctx (Term.App t u) = EApp (toE ctx t) (toE ctx u)
  toE ctx (Term.Var var) = 
    case elemIndex var ctx of
      Just ix => Bound ix
      Nothing => Free var

||| Perform the substitution `t[ i := e ]`.
||| @i a variable index
||| @t the original term
||| @e an expression that the bound variable at depth 'i' will be replaced with
export total
substitute : (i : Nat) 
          -> (t : Expr)
          -> (e : Expr) 
          -> Expr
substitute i term e = 
  case term of
    (Bound n)    => if n == i then e else Bound n
    (EApp e1 e2) => EApp (substitute i e1 e) (substitute i e2 e)
    (ELam e1)    => ELam (substitute (succ i) e1 e)
    (Free _)     => term

||| Beta-reduction, defined in terms of 'substitute'.
||| @t the term to apply the reduction to
export total reduce : (t : Expr) -> Expr
reduce (EApp (ELam t) s) = substitute 0 t s 
reduce term = term
