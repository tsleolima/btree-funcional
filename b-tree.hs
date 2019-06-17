-- Ordem dada pelo valor do INT

data BTree a = Leaf Int [a] | Node Int [a] [BTree a] deriving Show

a = (Leaf 3 [])
b = (Node 3 [2,5] [Leaf 3 [1],Leaf 3 [3,4],Leaf 3 [10]])
c = (Node 3 [3,10] [Node 3 [1] [Leaf 3 [0],Leaf 3 [2]],Node 3 [5] [Leaf 3 [4],Leaf 3 [6]],Node 3 [21] [Leaf 3 [20],Leaf 3 [22]]])

search (Leaf o []) elem = False
search (Leaf o (x:xs)) elem
 | elem == x = True
 | elem < x = False
 | elem > x = search (Leaf o xs) elem

search (Node o [] (y:ys)) elem = search y elem
search (Node o (x:xs) (y:ys)) elem
 | elem == x = True
 | elem < x = search y elem
 | elem > x = search (Node o xs ys) elem

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

insert' (Node o [] (t:ts)) elem = if isFull tree then (split tree)
                                  else Node o [] [tree]
                                  where tree = insert' t elem

insert' node@(Node o chaves@(x:xs) (y:ys)) elem 
 | elem == x = node
 | elem < x = if isFull tree then (Node o (mediana:x:xs) (left:right:ys))     
              else (Node o chaves (tree:ys))
 | elem > x = Node o (x:novoXs) (y:novoYs)
 where Node _ [mediana] [left,right] = split tree
       Node _ novoXs novoYs = insert' (Node o xs ys) elem
       tree = insert' y elem

split (Leaf o chaves) = (Node o [mediana] [Leaf o left, Leaf o right])
 where left = leftHalf chaves
       mediana:right = halfRight chaves

split (Node o chaves trees) = Node o [mediana] [Node o left t1, Node o right t2]
 where left = leftHalf chaves
       mediana:right = halfRight chaves
       t1 = leftHalf trees
       t2 = halfRight trees

isFull (Leaf _ []) = False
isFull (Leaf o xs) = (o -1) < length xs
isFull (Node o xs _) = (o -1) < length xs

leftHalf xs = take ( div (length xs) 2 ) xs
halfRight xs = drop ( div (length xs) 2 ) xs

removeKey e xs = if (e `elem` xs) then removeKey' e xs else xs
removeKey' e (x:xs)
 | e == x = xs
 | otherwise = x:(removeKey' e xs)

--contrario do isFull
isShort (Leaf _ []) = True
isShort (Leaf o xs) = ((o-1) `div` 2) > length xs
isShort (Node o xs _) = ((o-1) `div` 2) > length xs

-- merge: junta as duas paginas de uma mesma chave k
merge k (Leaf o keys1) (Leaf _ keys2) = Leaf o (keys1 ++ [k] ++ keys2)
merge k (Node o keys1 t1) (Node _ keys2 t2) = Node o (keys1 ++ [k] ++ keys2) (t1 ++ t2)

removeLeaf (Leaf o ks) x = Leaf o (removeKey x ks)

remove l@(Leaf o ks) elem
 | isShort leaf = error "Unimplemented"
 | otherwise = leaf
 where leaf = removeLeaf l elem
 
remove (Node o [k] [t1, t2]) e
 | e == k = error "Unimplemented"
 | e < k = (Node o [k] [(remove t1 e), t2])
 | e > k = (Node o [k] [t1, (remove t2 e)])

remove (Node o (k:ks) (t:ts)) e
 | e == k = error "Unimplemented"
 | e < k = (Node o (k:ks) ((remove t e):ts))
 | e > k = (Node o (k:newKs) (t:newTs))
 where Node _ newKs newTs = remove (Node o ks ts) e

 --TODO: Remover de um no; Remover de uma folha que ja tem o minimo de chaves.