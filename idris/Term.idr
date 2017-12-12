module Term

import Lightyear
import Lightyear.Char
import Lightyear.Strings

export data Term
  = Var String         -- Variable
  | App Term Term      -- Application
  | Lam String Term    -- Lambda abstraction

export Show Term where
  show (Var var) = var
  show (App t u) = "(" ++ show t ++ " "
                       ++ show u ++ ")"
  show (Lam x t) = "~" ++ x ++ "." ++ show t

name : Parser String
name = do
  let name = !letter :: !(many alphaNum)
  pure (pack name)

lambda : Parser Term -> Parser Term
lambda term = do
  char '~'
  var <- name
  char '.'
  body <- term
  pure (Lam var body)

export term : Parser Term
term = do
  terms <- some (spaces *> expr)
  pure (foldl1 App terms)
where
  expr : Parser Term
  expr = map Var name  -- x
    <|>| lambda term   -- ~x.M
    <|>| parens term   -- (M)
