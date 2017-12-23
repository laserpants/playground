module Tests.Term

import Lightyear
import Lightyear.Strings
import Expr
import Term

lam : Expr -> Expr
lam e = ELam e ""

term1_1 : Expr
term1_1 = 
  lam (EApp 
    (lam (EApp 
      (lam (EApp 
        (lam (lam (lam (lam (EApp 
          (Bound 6) 
          (Bound 5)))))) 
        (lam (Bound 0)))) 
      (Bound 1))) 
    (lam (lam (EApp 
      (lam (Bound 3)) 
      (lam (Bound 1)))))) 

term1_2 : Expr
term1_2 =
  lam (EApp 
    (lam (EApp 
      (lam (lam (lam (lam (EApp 
        (Bound 5) 
        (lam (lam (EApp 
          (lam (Bound 8)) 
          (lam (Bound 1)))))))))) 
      (lam (Bound 0)))) 
    (Bound 0))

term1_3 : Expr
term1_3 = 
  lam (EApp 
    (lam (lam (lam (lam (EApp 
      (Bound 4) 
      (lam (lam (EApp 
        (lam (Bound 7)) 
        (lam (Bound 1)))))))))) 
    (lam (Bound 0)))

term1_4 : Expr
term1_4 = 
  lam (lam (lam (lam (EApp 
    (Bound 3) 
    (lam (lam (EApp 
      (lam (Bound 6)) 
      (lam (Bound 1)))))))))

term1_5 : Expr
term1_5 = 
  lam (lam (lam (lam (EApp 
    (Bound 3) 
    (lam (lam (Bound 5)))))))

term2_1 : Expr
term2_1 = 
  EApp 
    (lam (lam (EApp 
      (Bound 1) 
      (Bound 0)))) 
    (lam (lam (EApp 
      (Bound 1) 
      (Bound 0))))

term2_2 : Expr
term2_2 = 
  lam (EApp 
    (lam (lam (EApp 
      (Bound 1) 
      (Bound 0)))) 
    (Bound 0))

term2_3 : Expr
term2_3 = 
  lam (lam (EApp 
    (Bound 1) 
    (Bound 0)))

test1 : IO ()
test1 = do
  printLn (reduce term1_1 == term1_2)
  printLn (reduce term1_2 == term1_3)
  printLn (reduce term1_3 == term1_4)
  printLn (reduce term1_4 == term1_5)
  printLn (reduce term1_5 == term1_5)
  printLn (reduce term2_1 == term2_2)
  printLn (reduce term2_2 == term2_3)

export tests : IO ()
tests = test1

-- testShow : String -> IO ()
-- testShow input =
--   case parseTerm input of
--     Left  _ => putStrLn "No parse"
--     Right t => do 
--       let rhs = parseTerm (show t)
--       putStrLn (show t)
--       if (Right t == rhs)
--           then putStrLn "\x2714 Ok"
--           else putStrLn ("Error: " ++ show rhs ++ " /= " ++ input)
-- 
-- --    Left  _ => pure False
-- --    Right t => do 
-- --      printLn t
-- --      printLn (parseTerm (show t))
-- --      pure (Right t == parseTerm (show t))
-- 
-- testToExpr : String -> Expr -> IO ()
-- testToExpr input expr = 
--   if Right expr == rhs
--     then putStrLn "\x2714 Ok"
--     else putStrLn ("Error: " ++ show rhs ++ " /= " ++ show expr)
-- where
--   rhs : Either String Expr
--   rhs = map toExpr (parse term input) 
-- 
-- testParseTerm : String -> String -> IO ()
-- testParseTerm input match =
--   if Right match == rhs
--     then putStrLn "\x2714 Ok"
--     else putStrLn ("Error: " ++ show rhs ++ " /= " ++ match)
-- where
--   rhs : Either String String
--   rhs = map show (parse term input)
-- 
-- testShowExpr : String -> String -> IO ()
-- testShowExpr input match =
--   if lhs == Right match
--     then putStrLn "\x2714 Ok"
--     else putStrLn ("Error: " ++ input ++ " /= " ++ match)
-- where
--   lhs : Either String String
--   lhs = show . toExpr <$> parse term input
-- 
-- fromRight : Either a b -> b
-- fromRight (Right r) = r
-- 
-- expr_ : String -> Expr 
-- expr_ = fromRight . map toExpr . parseTerm 
-- 
-- testExprEq : Expr -> Expr -> IO ()
-- testExprEq x y =
--   if x == y
--     then putStrLn "\x2714 Ok"
--     else putStrLn ("Error: " ++ show x ++ " /= " ++ show y)
-- 
-- testReduce : String -> Expr -> IO ()
-- testReduce input exp = 
--   if lhs == Right exp
--     then putStrLn "\x2714 Ok"
--     else putStrLn ("Error: " ++ input ++ " /= " ++ show lhs)
-- where
--   lhs : Either String Expr
--   lhs = map (reduce . toExpr) (parseTerm input)
-- 
-- testSubst : Nat -> Expr -> Expr -> Expr -> IO ()
-- testSubst i term e e1 = 
--   if lhs == e1
--     then putStrLn "\x2714 Ok"
--     else putStrLn ("Error: " ++ show e1 ++ " /= " ++ show lhs)
-- where
--   lhs : Expr
--   lhs = substitute i term e
-- 
-- export tests : IO ()
-- tests = do
--   --
-- --  testParseTerm "x y" "(x y)"
-- --  testParseTerm "x x" "(x x)"
-- --  testParseTerm "~x.x" "(~x.x)"
-- --  testParseTerm "~x.(x x)" "(~x.(x x))"
-- --  testParseTerm "(x x)(x x)" "((x x) (x x))"
-- --  testParseTerm "(((x y) z) a)" "(((x y) z) a)"
-- --  testParseTerm "(x (y (z a)))" "(x (y (z a)))"
-- --  testParseTerm "z" "z"
-- --  testParseTerm "(a b) z" "((a b) z)"
-- --  testParseTerm "~z.a b z" "(~z.((a b) z))"
-- --  testParseTerm "~y.~z.a b z" "(~y.(~z.((a b) z)))"
-- --  testParseTerm "(~x.x)" "(~x.x)"
-- --  testParseTerm "wat dat" "(wat dat)"
-- --  --
-- --  testToExpr "~x.x" (ELam (Bound 0))
-- --  testToExpr "~y.y" (ELam (Bound 0))
-- --  testToExpr "~x.x y" (ELam (EApp (Bound 0) (Free "y")))
-- --  testToExpr "~x.~y.y x" (ELam (ELam (EApp (Bound 0) (Bound 1))))
-- --  testToExpr "a b" (EApp (Free "a") (Free "b"))
-- --  testToExpr "(~x.(~x.(~x.x x) x) x)" (ELam (EApp (ELam (EApp (ELam (EApp (Bound 0) (Bound 0))) (Bound 0))) (Bound 0)))
-- --  testToExpr "(~x.(~y.x y) x)" (ELam (EApp (ELam (EApp (Bound 1) (Bound 0))) (Bound 0)))
-- --  --
-- --  testShowExpr "~x.x" "(λ 0)"
-- --  testShowExpr "~y.y" "(λ 0)"
-- --  testShowExpr "~x.~y.y x" "(λ (λ 0 1))"
-- --  testShowExpr "a b" "a b"
-- --  testShowExpr "(a b) c" "a b c"
-- --  testShowExpr "a (b c)" "a (b c)"
-- --  testShowExpr "a b c d" "a b c d"
-- --  testShowExpr "((a b) c) d" "a b c d"
-- --  testShowExpr "a (b (c d))" "a (b (c d))"
-- --  testShowExpr "a (b c) d" "a (b c) d"
-- --  testShowExpr "a (b c d)" "a (b c d)"
-- --  --
-- --  testExprEq (expr_ "~f.~x.f x") (reduce (reduce (reduce (expr_ "(~n.~f.~x.f (n f x)) (~f.~x.x)"))))
-- --  --
-- --  testReduce "(~x.x) v" (Free "v") 
-- --              -- (\x.x)v       ==> v
-- --  testReduce "(~x.~y.x) v" (ELam (Free "v")) 
-- --              -- (\x.\y.x)v    ==> \y.v
-- --  testReduce "(~x.~y.~z.x) v" (ELam (ELam (Free "v"))) 
-- --              -- (\x.\y.\z.x)v ==> \y.\z.v
-- --  testReduce "(~x.~y.~z.y) v" (ELam (ELam (Bound 1))) 
-- --              -- (\x.\y.\z.y)v ==> \y.\z.y
-- --  testReduce "(~x.~y.~z.z) v" (ELam (ELam (Bound 0))) 
-- --              -- (\x.\y.\z.z)v ==> \y.\z.z
-- --  testReduce "(~x.~x.~x.x) y" (ELam (ELam (Bound 0))) 
-- --              -- (\x.\x.\x.x)y ==> \x.\x.x
-- --  testReduce "(~x.v) v" (Free "v") 
-- --              -- (\x.v)v       ==> v
-- --  testReduce "(u v)" (EApp (Free "u") (Free "v"))
-- --              -- u v           ==> u v
-- --  testSubst 0 (ELam (ELam (Bound 2))) (Free "v") (ELam (ELam (Free "v")))
-- --              -- (\x.\x.#2)[ 0 := v ] ==> \x.\x.v
-- --  testSubst 0 (ELam (ELam (Bound 3))) (Free "v") (ELam (ELam (Bound 3)))
-- --              -- (\x.\x.#3)[ 0 := v ] ==> \x.\x.#3
-- --  testSubst 0 (ELam (ELam (Bound 3))) (Free "v") (ELam (ELam (Bound 3)))
-- --              -- (\x.\x.#1)[ 0 := v ] ==> \x.\x.#3
-- --  --
-- --  -- SUCC 0
-- --  --
-- --  let succ_0 = expr_ "(~n.~f.~x.f (n f x)) (~f.~x.x)"
-- --  -- (λ (λ (λ 1 (2 1 0)))) (λ (λ 0))
-- --  testExprEq (reduce succ_0) (expr_ "(~f.~x.f ((~g.~y.y) f x))")
-- --  -- (λ (λ 1 ((λ (λ 0)) 1 0)))
-- --  testExprEq (reduce (reduce succ_0)) (expr_ "(~f.~x.f ((~y.y) x))")
-- --  -- (λ (λ 1 ((λ 0) 0)))
-- --  testExprEq (reduce (reduce (reduce succ_0))) (expr_ "(~f.~x.f x)")
-- --  -- (λ (λ 1 0))
-- --  -- No more reduction possible
-- --  testExprEq (reduce (reduce (reduce (reduce succ_0)))) (expr_ "(~f.~x.f x)")
-- --  -- (λ (λ 1 0))
-- --  -- 
-- --  -- PLUS 2 3
-- --  -- 
-- --  let plus_2_3 = expr_ "(~m.~n.~f.~x.m f (n f x)) (~f.~x.f (f x)) (~f.~x.f (f (f x)))"
-- --  -- (λ (λ (λ (λ 3 1 (2 1 0))))) (λ (λ 1 (1 0))) (λ (λ 1 (1 (1 0))))
-- --  testExprEq (reduce plus_2_3) (expr_ "(~n.~f.~x.(~f.~x.f (f x)) f (n f x)) (~f.~x.f (f (f x)))")
-- --  -- (λ (λ (λ (λ (λ 1 (1 0))) 1 (2 1 0)))) (λ (λ 1 (1 (1 0))))
-- --  testExprEq (reduce (reduce plus_2_3)) (expr_ "(~f.~x.(~f.~x.f (f x)) f ((~f.~x.f (f (f x))) f x))")
-- --  -- (λ (λ (λ (λ 1 (1 0))) 1 ((λ (λ 1 (1 (1 0)))) 1 0)))
-- --  testExprEq (reduce (reduce (reduce plus_2_3))) (expr_ "(~d.~c.(~a.c (c a)) ((~b.c (c (c b))) c))")
-- --  -- (λ (λ (λ 1 (1 0)) ((λ 1 (1 (1 0))) 0)))
-- --  testExprEq (reduce (reduce (reduce (reduce plus_2_3)))) (expr_ "(~d.~c.(d (d ((~b.c (c (c b))) c))))")
-- --  -- (λ (λ 1 (1 ((λ 1 (1 (1 0))) 0))))
-- --  testExprEq (reduce (reduce (reduce (reduce (reduce plus_2_3))))) (expr_ "(~d.~c.d (d (d (d (d c)))))")
-- --  -- (λ (λ 1 (1 (1 (1 (1 0))))))
-- --  -- No more reduction possible
-- --  testExprEq (reduce (reduce (reduce (reduce (reduce (reduce plus_2_3)))))) (expr_ "(~d.~c.d (d (d (d (d c)))))")
-- --  -- (λ (λ 1 (1 (1 (1 (1 0))))))
-- --
--   testShow "(~n.~f.~x.f (n f x)) (~f.~x.x)"
--   testShow "(~m.~n.~f.~x.m f (n f x)) (~f.~x.f (f x)) (~f.~x.f (f (f x)))"
--   testShow "x y" 
--   testShow "x x" 
--   testShow "~x.x"
--   testShow "~x.(x x)" 
--   testShow "(x x)(x x)"
--   testShow "(((x y) z) a)" 
--   testShow "(x (y (z a)))" 
--   testShow "z" 
--   testShow "(a b) z"
--   testShow "~z.a b z"
--   testShow "~y.~z.a b z"
--   testShow "(~x.x)"
--   testShow "wat dat"
--   testShow "~x.x"
--   testShow "~y.y"
--   testShow "~x.x y"
--   testShow "~x.~y.y x"
--   testShow "a b" 
--   testShow "(~x.(~x.(~x.x x) x) x)"
--   testShow "(~x.(~y.x y) x)" 
--   testShow "~x.x"
--   testShow "~y.y"
--   testShow "~x.~y.y x"
--   testShow "a b" 
--   testShow "(a b) c"
--   testShow "a (b c)"
--   testShow "a b c d"
--   testShow "((a b) c) d"
--   testShow "a (b (c d))"
--   testShow "a (b c) d" 
--   testShow "a (b c d)"
--   testShow "~x.x ~x.x"
--   testShow "(~x.x) (~x.x)"
--   testShow "(x (x x) x)"
--   testShow "(x x (x x))"
--   testShow "(x x x x)"
--   testShow "~x.~y.~z.x y z"
--   testShow "~x.~y.~z.z"
--   testShow "~x.~y.~z.x (y z)"
--   testShow "(~d.~c.d (d (d (d (d c)))))"
