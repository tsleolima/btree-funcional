-- Ordem dada pelo valor do INT

data BTree a = Nil Int | Leaf Int [a] | Node Int [a] [BTree a] deriving Show

a = (Leaf 3 [])
 
insertOrdered a [] = [a]
insertOrdered a bs'@(b:bs)
 | a <= b    = a : bs'
 | otherwise = b : insertOrdered a bs

insert bt elem
 | isFull tree = split tree
 | otherwise = tree
 where tree = insert' bt elem

insert' (Leaf o []) elem = Leaf o [elem]
insert' tree@(Leaf o chaves@(k:ks)) elem
 | elem == k = tree
 | elem < k  = Leaf o (elem:chaves)
 | elem > k  = Leaf o (insertOrdered elem chaves)

insert' node@(Node o chaves@(x:xs) (y:ys)) elem 
 | elem == x = node
 | elem < x = if isFull y then (Node o (mediana:x:xs) [left,right,ys]) elem
              else (Node o chaves (insert' y elem):ys)
 | elem > x = Node o (x:novoXs) (y:novoYs)
 where Node _ [mediana] [left,right] = split y
       Node _ novoXs novoYs = insert' (Node o xs ys) elem

split (Leaf o chaves) = (Node o [mediana] [Leaf o left, Leaf o right])
 where left = leftHalf chaves
       mediana:right = halfRight chaves

split (Node o chaves trees) = Node o [mediana] [Node o c1 t1, Node o c2, t2]
 where left = leftHalf chaves
       mediana:right = halfRight chaves
       t1 = leftHalf trees
       t2 = halfRight trees

isFull (Leaf _ []) = False
isFull (Leaf o xs)
 | ((o -1) < length xs) = True
 | otherwise = False

isFull (Node o xs _)
 | ((o -1) < length xs) = True
 | otherwise = False

leftHalf xs = take ( div (length xs) 2 ) xs
halfRight xs = drop ( div (length xs) 2 ) xs