let NKEYS = 3;

function insereOrdenado(lista,valor) {

    if(valor < head(lista) || lista.length == 0){
        lista.unshift(valor); 
        return lista;
    }
    if(valor > head(lista)){
        return [head(lista)].concat(insereOrdenado(tail(lista),valor))
    }
}

function head(list){
    return list.filter(value => !(list.slice(1)).includes(value))[0]
}

function tail(list){        
    return list.filter(value => (list.slice(1)).includes(value))
}

function BTreeNode(key,subtree) {
    if(key && subtree){
        this.keys = key;
        this.childs = subtree;
    } else if (key) {
        this.keys = key;
        this.childs = [];
    } else {
        this.keys = [];
        this.childs = [];
    }
}

function isLeaf(tree) {
    return (tree.childs.length == 0);
}

function isFull(tree) {
    return ((NKEYS - 1) < tree.keys.length);
};

function search(node,elem){
    if (node.keys.length == 0) {
        return false;
    }
    if (node.keys.includes(elem)) {
        return true;
    }
    
    return node.childs.map(v => search(v,elem)).some(
        v => v==true)
}

function insert(tree,elem) {    
    var btree = _insert(tree,elem);
    if (isFull(btree)) {   
        return split(btree);
    } else {       
        return btree;
    }
}

function _insert(ok,elem) {
    var node = ok;
    if(isLeaf(node)){
        if (elem == head(node.keys)){
            return node;
        }
        node.keys = insereOrdenado(node.keys,elem);
        return node;
    } else {         
        if (elem == head(node.keys)){
            return node;
        }
        else if (elem < head(node.keys)){
            var tree = _insert(head(node.childs),elem);
            if(isFull(tree)){
                var splited = split(tree);
                var left = leftHalf(splited.childs);
                var rigth = halfRigth(splited.childs);
                var h = head(node.keys);
                var t = tail(node.keys);
                var ys = tail(node.childs);
                node.keys = [splited.keys[0]].concat(h).concat(t)
                node.childs = left.concat(rigth).concat(ys)
                return node;
            } else {
                var ys = tail(node.childs);
                node.childs = [tree].concat(ys)
                return node;
            }
        } else {   
            if (node.keys.length == 0) {
                var tree = _insert(head(node.childs),elem);
                if(isFull(tree)){
                    return split(tree)
                } else {
                    var curr = new BTreeNode();
                    curr.childs.push(tree);
                    return curr;
                }
            }         
            var noder = new BTreeNode();
            var inNode = new BTreeNode();
            inNode.keys = tail(node.keys);
            inNode.childs = tail(node.childs);
            var curr = _insert(inNode,elem);
            var novaChave = curr.keys;
            var novaTrees = curr.childs;
            noder.keys = [head(node.keys)].concat(novaChave);
            noder.childs = [head(node.childs)].concat(novaTrees);
            return noder;
        }
    } 
}

function split(tree) {
    var newBtree = new BTreeNode();
    var left = leftHalf(tree.keys);
    var rigth = halfRigth(tree.keys);
    var mediana = head(rigth);
    if (isLeaf(tree)) {
        newBtree.keys.push(mediana);
        newBtree.childs.push(new BTreeNode(left));
        newBtree.childs.push(new BTreeNode(tail(rigth)));  
        return newBtree;
    } else {    
        var leftTrees = leftHalf(tree.childs);
        var rigthTrees = halfRigth(tree.childs);         
        newBtree.keys.push(mediana);
        newBtree.childs.push(new BTreeNode(left,leftTrees));
        newBtree.childs.push(new BTreeNode(tail(rigth),rigthTrees));
        return newBtree;
    }
}

function leftHalf(lista) {
    return lista.slice(0,(lista.length/2))
}

function halfRigth(lista) {
    return lista.slice((lista.length/2))
}

function toJSON(tree) {
    var json = {};
    json.name = tree.keys.toString();
    if (!isLeaf(tree)) {
      json.children = [];
      tree.childs.forEach(function(child){
        json.children.push(toJSON(child));
      });
    }
    return json;
}

/**
 * Pega o parent de um nó
 * @param {} tree 
 * @param {*} key 
 */
function getParent(tree, no) {
    const node = reduceArrays(_getParent(tree, searchNodeByKey(tree,
        typeof no === 'number' ? no : head(no.keys))));
    if(node instanceof Array) {
        return node.filter(subtree => subtree instanceof BTreeNode).length > 0 ?
            head(node.filter(subtree => subtree instanceof BTreeNode)) : null;
    } else {
       return node
    }
}

function _getParent(tree, node) {
    if(!isLeaf(tree) && tree.childs.some(no => no.keys === node.keys)) {
        return tree;
    }
    return tree.childs.map(no => _getParent(no, node));
}
/**
 * Pega o no adjacente a esquerda
 */
function leftAdj(tree, node) {
    const parent = getParent(tree, node);
    if(parent.childs.length > 1) { 
        return parent.childs.indexOf(node) > 0 ?
            parent.childs[parent.childs.indexOf(node) - 1] : null;
    }
}

/**
 * Pega o no adjacente a direita
 */
function rightAdj(tree, node) {
    const parent = getParent(tree, node);
    if(parent.childs.length > 1) { 
        return parent.childs.indexOf(node) + 1 < parent.childs.length ?
            parent.childs[parent.childs.indexOf(node) + 1] : null;
    }
}


/**
 * Reduz matriz a uma lista 
 * @param {*} arrays 
 */
function reduceArrays(arrays) {
    if(arrays instanceof BTreeNode) {
        return arrays;
    }
    if(arrays && !arrays.some(elem => elem instanceof Array)) {
        return arrays;
    }
    return reduceArrays(arrays.reduce((a,b) => {return a.concat(b)}, []));
}

function _toArray(tree, list) {
    if(isLeaf(tree)) {
        return list.concat(tree.keys);
    } 
    return tree.childs.map(child => _toArray(child, list.concat(tree.keys)));
}

/**
 * Transforma a arvore em um array ordenado
 * @param {} tree 
 */
function toArray(tree) {
    return Array.from(new Set(reduceArrays(_toArray(tree, tree.keys))))
            .sort((a, b) => a - b);
}

function _searchNodeByKey(tree, key) {
    if(tree.keys.includes(key)) {
        return tree;
    } else if (!tree.keys.includes(key) && isLeaf(tree)) {
        return;
    }
    return tree.childs.map(child => _searchNodeByKey(child, key));
}

/**
 * Retorna a subtree que contem uma determinada Key como raíz
 * @param {*} tree 
 * @param {*} key 
 */
function searchNodeByKey(tree, key) {
    const node = reduceArrays(_searchNodeByKey(tree, key));
    if(node instanceof Array) {
        return node.filter(subtree => subtree instanceof BTreeNode).length > 0 ?
            head(node.filter(subtree => subtree instanceof BTreeNode)) : null;
    } else {
       return node
    }
}

function sucessor(tree, elem) {
    const order = toArray(tree);
    if(order.indexOf(elem) + 1 < order.length) {
        return order[order.indexOf(elem) + 1];
    }
    return null;
}

function predecessor(tree, elem) {
    const order = toArray(tree);
    if(order.indexOf(elem) > 0) {
        return order[order.indexOf(elem) - 1];
    }
    return null;
}

function remove(tree, key) {

}

let btree = new BTreeNode();
// FAZER OS INSERTS EXATAMENTE NESSA ORDEM LA NA VIEW
// POIS SE FIZER DIFERENTE A ARVORE FINAL PODE SER DIFERENTE
// E AS VERIFICACOES DOS CONSOLE.LOG PODE CONFUNDIR UM POUCO
// (PASSEI UM BOM TEMPO TENTANDO ENTENDER PQ OS CONSOLE.LOG TAVA DIFERENTE DO QUE EU VIA NA ARVORE,
// E NA REAL FOI PORQUE LA NA VIEW EU INSERI EM OUTRA ORDEM)
btree = insert(btree, 8);
btree = insert(btree, 6);
btree = insert(btree, 1);
btree = insert(btree, 2);
btree = insert(btree, 3);
btree = insert(btree, 4);
btree = insert(btree, 13);
btree = insert(btree, 10);
btree = insert(btree, 5);
btree = insert(btree, 7);
btree = insert(btree, 9);
btree = insert(btree, 11);
btree = insert(btree, 12);
btree = insert(btree, 14);
btree = insert(btree, 15);
btree = insert(btree, 16);
btree = insert(btree, 17);
btree = insert(btree, 18);
btree = insert(btree, 19);
btree = insert(btree, 20);
btree = insert(btree, 21);
btree = insert(btree, 22);
btree = insert(btree, 23);
btree = insert(btree, 24);

//teste
function imprime(tree) {
    if(!isLeaf(tree)) {
        console.log(tree);
        tree.childs.map(e => imprime(e));
    }
    console.log(tree);
}

console.log("No inteiro");
console.log(searchNodeByKey(btree, 16));
console.log("sucessor");
console.log(sucessor(btree, 16));
console.log("predecessor");
console.log(predecessor(btree, 16)); 
console.log("Pai de um no");
console.log(getParent(btree, 16));
console.log("Adjacente esquerdo");
console.log(leftAdj(btree, searchNodeByKey(btree, 16)));
console.log("Adjacente direito");
console.log(rightAdj(btree, searchNodeByKey(btree, 16)));

