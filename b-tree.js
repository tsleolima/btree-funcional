const NKEYS = 2;

function BTreeNode() {
    this.keys = [10];
    this.childs = [
        { keys: [5], childs: []},
        { keys: [20], childs: []}
    ];
}

function isFull(tree) {
    console.log((NKEYS - 1) < tree.keys.length)
    return ((NKEYS - 1) < tree.keys.length);
};

function head(list){
    return list.filter(value => !(list.slice(1)).includes(value))
}

function tail(list){
    return list.filter(value => (list.slice(1)).includes(value))
}

function search(node,elem){
    if (node.keys.length == 0) {
        return false;
    }
    if (node.keys.includes(elem)) {
        return true;
    }
    
    return node.childs.map(v => search(v,elem)).every(
        v => v==true)
}

function insert(elem) {
    var tree = this._insert(this,elem);
    if (this.isFull(tree)) {
        return this.split(tree);
    } else {
        return tree;
    }
}

function _insert(elem) {

}

var btree = new BTreeNode();
console.log(search(btree,5))