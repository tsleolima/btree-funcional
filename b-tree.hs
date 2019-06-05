-- Ordem dada pelo valor do INT

data BTree a = Nil Int | Leaf Int [a] | Node Int [a] [BTree a] deriving Show

a = (Node 3 [30] [Leaf 3 [20],Leaf 3 [35,38,40]])
 
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

insert t x 
 | isFull t = insert (split t) x
 | otherwise = insert t x

isFull (Nil m) = False
isFull (Leaf _ []) = False
isFull (Leaf o xs)
 | ((o -1) <= length xs) = True
 | otherwise = False

isFull (Node o xs _)
 | (o -1) <= length xs = True
 | otherwise = False

split (Node o xs ys) = (Node o xs [Leaf o leftHalf, Leaf o rigthHalf])

leftHalf xs = take (ceiling ((length xs)/2))
rigthHalf xs = drop (ceiling ((length xs/2))