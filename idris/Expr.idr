module Expr

import Term 

||| De Bruijn-indexed intermediate lambda term data type representation.
||| 
||| In this scheme, the two alpha equivalent terms ~x.x and ~y.y are both 
||| represented in canonical form, as `ELam (Bound 0)`.
public export data Expr = 
  ||| Bound variable (depth indexed)
  Bound Nat String |
  ||| Free variable
  Free String |   
  ||| Application
  EApp Expr Expr |
  ||| Lambda abstraction
  ELam Expr

export Eq Expr where
  (Bound a _) == (Bound b _) = a == b
  (Free a)    == (Free b)    = a == b
  (EApp t v)  == (EApp u w)  = t == u && v == w
  (ELam t)    == (ELam u)    = t == u
  _           == _           = False

export Show Expr where
  show (Bound a v) = "Bound "  ++ show a ++ " "
                               ++ v
  show (Free a)    = "Free \"" ++ show a ++ "\""
  show (EApp t u)  = "EApp ("  ++ show t ++ ") (" 
                               ++ show u ++ ")"
  show (ELam t)    = "ELam ("  ++ show t ++ ")"

-- @TODO rename to fromTerm

||| Translate a `Term` value to a canonical `Expr` representation, using so 
||| called De Bruijn indexing.
||| @t the input term
export total 
fromTerm : (t : Term) -> Expr
fromTerm = toe [] where
  toe : List String -> Term -> Expr
  toe ctx (Term.Lam x t) = ELam (toe new_ctx t) where new_ctx = x :: ctx
  toe ctx (Term.App t u) = EApp (toe ctx t) (toe ctx u)
  toe ctx (Term.Var var) = 
    case elemIndex var ctx of
      Just ix => Bound ix var
      Nothing => Free var

toTerm : Expr -> Term
toTerm = ?x

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
    (Bound n v) => 
      case compare n i of
        GT => Bound (pred n) v
        LT => Bound n v
        EQ => reindexed 0 e
    (EApp e1 e2) => EApp (substitute i e1 e) (substitute i e2 e)
    (ELam e1)    => ELam (substitute (succ i) e1 e)
    (Free _)     => term
where
  reindexed : Nat -> Expr -> Expr
  reindexed j expr = 
    case expr of 
      (Bound n v)  => Bound (if n >= j then n + i else n) v
      (EApp e1 e2) => EApp (reindexed j e1) (reindexed j e2)
      (ELam e1)    => ELam (reindexed (succ j) e1)
      (Free _)     => expr

||| Beta-reduction in /normal order/, defined in terms of 'substitute'.
||| @t the term to apply the reduction to
export total reduce : (t : Expr) -> Expr
reduce (EApp (ELam t) s) = substitute 0 t s
reduce (EApp t u)        = EApp (reduce t) (reduce u)
reduce (ELam lam)        = ELam (reduce lam)
reduce term              = term
