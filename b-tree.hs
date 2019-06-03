-- Ordem dada pelo valor do INT

data Tree a = Nil Int | Leaf Int [a] | Node Int [a] [Tree a] deriving Show

a = (Node 3 [30] [Leaf 3 [20],Leaf 3 [35,38]])

