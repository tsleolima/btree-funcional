import Btree
import Test.HUnit

--Para executar os testes, chame a funcao 'runTests'

a = (Leaf 3 [])
b = (Node 3 [2,5] [Leaf 3 [1],Leaf 3 [3,4],Leaf 3 [10]])
c = (Node 3 [3,10] [Node 3 [1] [Leaf 3 [0],Leaf 3 [2]],Node 3 [5] [Leaf 3 [4],Leaf 3 [6]],Node 3 [21] [Leaf 3 [20],Leaf 3 [22]]])

bremove3 = (Node 3 [2,5] [Leaf 3 [1],Leaf 3 [4],Leaf 3 [10]])
bremove4 = (Node 3 [2,5] [Leaf 3 [1],Leaf 3 [3],Leaf 3 [10]])

aInsert5 = (Leaf 3 [5])
bInsert8 = (Node 3 [2,5] [Leaf 3 [1],Leaf 3 [3,4],Leaf 3 [8,10]])
bInsert8p9 = (Node 3 [5] [Node 3 [2] [Leaf 3 [1],Leaf 3 [3,4]], Node 3 [9] [Leaf 3 [8], Leaf 3 [10]]])
toC = (Node 3 [3] [Node 3 [1] [Leaf 3 [0],Leaf 3 [2]],Node 3 [5,10] [Leaf 3 [4],Leaf 3 [6],Leaf 3 [20, 21]]])


testSearch = [
    TestCase (assertBool "search0" (search b 2)),
    TestCase (assertEqual "search1" False (search b 6)),
    TestCase (assertBool "search3" (search b 4)),
    TestCase (assertBool "search4" (search b 1)),
    TestCase (assertBool "search5" (search c 5))
    ]
testRemove = [
    TestCase (assertEqual "remove0" bremove3 (remove b 3)),
    TestCase (assertEqual "remove1" bremove4 (remove b 4))
    ]
testInsert = [
    TestCase (assertEqual "insert0" aInsert5 (insert a 5)),
    TestCase (assertEqual "insert1" bInsert8 (insert b 8)),
    TestCase (assertEqual "insert2" bInsert8p9 (insert bInsert8 9)),
    TestCase (assertEqual "insert3" c (insert toC 22))
    ]
testPredecessor = [
    TestCase (assertEqual "pred0" 4 (predecessor c 5)),
    TestCase (assertEqual "pred1" 6 (predecessor c 10)),
    TestCase (assertEqual "pred2" 2 (predecessor c 3)),
    TestCase (assertEqual "pred3" 20 (predecessor c 21)),
    TestCase (assertEqual "pred4" 3 (predecessor b 4))
    ]
testSuccessor = [
    TestCase (assertEqual "succ0" 4 (successor c 3)),
    TestCase (assertEqual "succ1" 20 (successor c 10))
    ]
testPreOrder = [
    TestCase (assertEqual "pre0" [3,1,0,2,10,5,4,6,21,20,22] (preOrder c)),
    TestCase (assertEqual "pre1" [2,1,5,3,4,10] (preOrder b)),
    TestCase (assertString (preOrder a))
    ]
testInOrder = [
    TestCase (assertEqual "in0" [0,1,2,3,4,5,6,10,20,21,22] (inOrder c)),
    TestCase (assertEqual "in1" [1,2,3,4,5,10] (inOrder b)),
    TestCase (assertString (inOrder a))
    ]
testPostOrder = [
    TestCase (assertEqual "post0" [0,2,1,4,6,5,20,22,21,10,3] (postOrder c)),
    TestCase (assertEqual "post1" [1,3,4,10,5,2] (postOrder b)),
    TestCase (assertString (postOrder a))
    ]
tests = TestList (testSearch ++ testRemove ++ testInsert ++ testPredecessor ++ testSuccessor ++ testPreOrder ++ testInOrder ++ testPostOrder)
runTests = runTestTT tests
