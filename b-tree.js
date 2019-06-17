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
