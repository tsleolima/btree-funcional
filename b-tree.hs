-- Ordem dada pelo valor do INT

data BTree a = Nil Int | Leaf Int [a] | Node Int [a] [BTree a] deriving Show

a = (Node 2 [30] [Leaf 2 [20],Leaf 2 [35,38,40]])
 
search (Nil _) _ = False
search (Leaf _ []) _ = False
search (Leaf o (x:xs)) elem 
 | x == elem = True
 | x > elem  = False
 | otherwise = search (Leaf o xs) elem

search (Node _ [] []) elem = False
search (Node _ [] (x:xs)) elem = search x elem
search (Node o (x:xs) (y:ys)) elem 
 | x == elem = True
 | x > elem  = search y elem
 | otherwise = search (Node o xs ys) elem