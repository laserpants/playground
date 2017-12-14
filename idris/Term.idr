module Term

import Lightyear
import Lightyear.Char
import Lightyear.Strings

||| In the lambda calculus, a term is one of three things:
||| * A variable is a term; 
||| * Application of two terms is a term; and
||| * A lambda abstraction is a term. 
|||
||| Nothing else is a term. Application is left-associative, so the term 
||| `(s t u)` is equivalent to `(s t) u`. One often omits outermost 
||| parentheses. In abstractions, the body extends as far to the right as 
||| possible.
public export data Term =
  ||| Variable
  Var String |
  ||| Application
  App Term Term |
  ||| Lambda abstraction
  Lam String Term    

export Show Term where
  show (Var var) = var
  show (App t u) = "(" ++ show t ++ " "
                       ++ show u ++ ")"
  show (Lam x t) = "~" ++ x ++ "." ++ show t

name : Parser String
name = do
  let name = !letter :: !(many alphaNum)
  pure (pack name)

||| Lambda abstraction parser. 
||| @t parser to use for the lambda body
lambda : (t : Parser Term) -> Parser Term
lambda term = do
  char '~'
  var <- name
  char '.'
  body <- term
  pure (Lam var body)

||| Main term parser. 
export term : Parser Term
term = do
  terms <- some (spaces *> expr)
  pure (foldl1 App terms)
where
  expr : Parser Term
  expr = map Var name  -- x
    <|>| lambda term   -- ~x.M
    <|>| parens term   -- (M)

||| Parse a lambda term and return either an error string (as `Left`), or the 
||| resulting `Term` value (as `Right`).
||| @input the input string
export parseTerm : (input : String) -> Either String Term
parseTerm = parse term 
