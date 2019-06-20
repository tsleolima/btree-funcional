var root;
var app = angular.module('myapp', []);
app.controller('myCtrl', function ($scope) {


    var btree;
    $scope.setOrder = function (valor) {
        btree = new BTreeNode();
        NKEYS = valor;
        window.alert("Ordem definida");
    }

    $scope.insert = function (valor) {
        if (btree == null) window.alert("Antes de inserir, indique a ordem para instanciar uma BTreeNode()");
        btree = insert(btree, Number(valor));        
        root = toJSON(btree);
        update(root);
    }

    $scope.remove = function (valor) {
        btree = remove(btree, Number(valor));
        root = toJSON(btree);
        update(root)
    }

    $scope.search = function (valor) {				
        const cloned = angular.copy(btree)				
        btree = insereNoPintado(btree,Number(valor));	
        root = toJSON(btree);
        update(root);
        btree = cloned; 
    }

});