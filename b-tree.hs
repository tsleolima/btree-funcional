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

predecessor (Leaf _ [x]) elem = if (elem > x) then x else error "ocorreu algum erro"
predecessor (Leaf o (x1:x2:xs)) elem
 | elem == x2 = x1
 | elem < x1 = error "sem predecessor"
 | elem > x1 = predecessor (Leaf o (x2:xs)) elem

predecessor (Node o (x:xs) ((y@(Leaf _ (k:_))):ys)) elem
 | elem == x = maxim y
 | elem == k = error "nao foi possivel achar o predecessor"
 | elem < x = predecessor y elem
 | null xs = x
 | elem > x = predecessor (Node o xs ys) elem

predecessor (Node _ [] (y:_)) elem = predecessor y elem
predecessor (Node o (x:xs) (y:ys)) elem
 | elem == x = maxim y
 | elem < x = predecessor y elem
 | elem > x = predecessor (Node o xs ys) elem

sucessor (Leaf _ [x]) elem = error "nenhum sucessor encontrado"
sucessor (Leaf o (x1:x2:xs)) elem
 | elem == x1 = x2
 | elem > x1 = sucessor (Leaf o (x2:xs)) elem
 | otherwise = error "sem sucessor"

sucessor (Node o (x:xs) ((y1@(Leaf _ (k:_))):y2:ys)) elem
 | elem == x = minim y2
 | elem == k = x
 | elem < x = predecessor y1 elem
 | null xs = x
 | elem > x = predecessor (Node o xs (y2:ys)) elem

sucessor (Node o [x] [y1, y2]) elem
 | elem == x = minim y2
 | elem > x = sucessor y2 elem
 | otherwise = error "algum erro aconteceu"

sucessor (Node o (x1:x2:xs) (y1:y2:ys)) elem
 | elem == x1 = minim y2
 | elem > x1 && elem < x2 = sucessor y2 elem
 | elem >= x2 = sucessor (Node o (x2:xs) (y2:ys)) elem
 | elem < x1 = sucessor y1 elem

-- retorna o filho esquerdo da chave k. OBS: o noh passado deve conter a chave k
leftChild (Node o (x:xs) (y:ys)) k
 | k == x = y
 | null xs = error "chave nao encontrada"
 | otherwise = leftChild (Node o xs ys) k

-- retorna o filho direito da chave k. OBS: o noh passado deve conter a chave k
rightChild (Node o (x:xs) (_:y2:ys)) k
 | k == x = y2
 | null xs = error "chave nao encontrada"
 | otherwise = rightChild (Node o xs (y2:ys)) k

maxim (Leaf _ keys) = last keys
maxim (Node _ _ trees) = maxim (last trees)

minim (Leaf _ keys) = head keys
minim (Node _ _ trees) = minim (head trees)

inOrder :: BTree a -> [a]
inOrder (Leaf _ xs) = xs
inOrder (Node _ [x] [y1,y2]) = (inOrder y1) ++ [x] ++ inOrder y2
inOrder (Node o (x:xs) (y:ys)) = (inOrder y) ++ [x] ++ inOrder (Node o xs ys)

preOrder :: Btree a -> [a]
preOrder (Leaf _ xs)= xs
preOrder (Node _ [x] [y1,y2]) = [x] ++ (preOrder y1) ++ preOrder y2
preOrder (Node o (x:xs) (y:ys)) = [x] ++ (preOrder y) ++ preOrder (Node o xs ys)

postOrder :: Btree a -> [a]
postOrder (Leaf _ xs)= xs
postOrder (Node _ [x] [y1,y2]) = (postOrder y1) ++ (postOrder y2) ++ [x]
postOrder (Node o (x:xs) (y:ys)) = (postOrder y) ++ (postOrder (Node o xs ys)) ++ [x] 