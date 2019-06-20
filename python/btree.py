# Author: Clara Moraes
# Date: 13/06/2019

# As implementações foram feitas beseadas no livro Introduction to Algorithms
# de Thomas Cormen, Charles Leiserson, Ronald Rivest e Clifford Stein. Cap.
# 18, B-trees.

# Conceitos de programação funcional utilizados: funções lambda, funções de alta
# ordem, filter

class BTreeNode(object):
	def __init__(self, is_leaf=False):
		self.is_leaf = is_leaf
		self.keys = []
		self.children = []


# Assumimos que não haverá chave repetida.
class BTree(object):
	def __init__(self, min_degree):
		self.root = BTreeNode(is_leaf=True)
		self.min_degree = min_degree


	def operation_values(self, operation, values):
		"""
			Realiza uma das operações definidas na árvore B em uma lista de valores.

			values: lista de valores a serem inseridos.
			operation: função que será aplicada na lista de valores
		"""
		for value in values:
			operation(value)


	def search(self, target, initial_node=None):
		"""
			Procura um valor na árvore.

			target: valor a ser procurado.
			initial_node: nó por onde a busca deve iniciar. O default valor default
			é a raiz da árvore.
		"""
		if isinstance(initial_node, BTreeNode):
			# Filtra todos os elementos menores que target. Como uma das propriedades da árvore B
			# é que as chaves estão ordenadas em ordem crescente, então o tamanho do array após o
			# filtro, será a posição do target.
			target_index = len(list(filter(lambda x: x < target, initial_node.keys)))

			if target_index < len(initial_node.keys) and target == initial_node.keys[target_index]:
				# Apenas para conferência de valores.
				print(initial_node, initial_node.keys[target_index])

				return initial_node

			elif initial_node.is_leaf:
				print("Not Found")

				return None

			else:
				return self.search(target, initial_node.children[target_index])

		else:
			self.search(target, self.root)

	def insert(self, value):
		"""
			Insere um novo valor (chave) na árvore.
			Assumimos que o usuário irá sempre usar uma função válida como parâmetro.

			value: valor da chave.
		"""

		root = self.root
		# O nó está na capacidade máxima, e precisa fazer o split
		# para que as propriedades da b-tree continuem válidas.
		if len(root.keys) == 2 * self.min_degree - 2:
			new_node = BTreeNode()
			self.root = new_node
			new_node.children.insert(0, root)
			self._split(new_node, 0)
			self._insert_not_full(new_node, value)

		else:
			self._insert_not_full(root, value)


	def _insert_not_full(self, node, value):
		"""
			Insere uma chave em um nó que não está cheio.

			node: nó da árvore candidato a armazenar a nova chave.
			value: valor da nova chave.
		"""

		# Se o nó for uma folha e não estiver no limite de sua capacidade, só precisamos
		# inserir a nova chave (value) no array ordenado.
		if node.is_leaf:
			# Fazemos cast pra list() por que em Python3 filter retorna um iterable
			less_than_value = list(filter(lambda x: x < value, node.keys))
			greater_than_value = list(filter(lambda x: x > value, node.keys))
			node.keys = less_than_value + [value] + greater_than_value

		# Se o nó não for folha, devemos descer na árvore para procurar a folha
		# em que o novo valor pode ser inserido.
		else:
			child_index = len(list(filter(lambda x: x < value, node.keys)))

			# Se a capacidade máxima do nó foi atingida, é preciso fazer o split.
			if len(node.children[child_index].keys) == 2 * self.min_degree - 2:
				self._split(node, child_index)

				if value > node.keys[child_index]:
					child_index += 1

			self._insert_not_full(node.children[child_index], value)

	def _split(self, node, index_split):
		"""
			Se um nó atinge a capacidade máxima de armazenamento então, para inserir
			um novo elemento, precisamos quebrar o nó atual criando assim dois nós com
			metade dos elementos do nó original (o que garante a propriedade de que 
			a quantidade de chaves é >= min_degree - 1).

			node: nó que atingiu a capacidade máxima.
			index_split: index de onde deve-se fazer a quebra do nó.
		"""
		new_left = node.children[index_split]
		new_right = BTreeNode(is_leaf=new_left.is_leaf)

		node.children.insert(index_split + 1, new_right)
		node.keys.insert(index_split, new_left.keys[self.min_degree - 1])

		new_right.keys = new_left.keys[self.min_degree:]
		new_left.keys = new_left.keys[:self.min_degree - 1]

		# Se o nó não for folha, então devemos definir seus filhos da esquerda e direita
		# após a quebra.
		if not new_left.is_leaf:
			new_right.children = new_left.children[self.min_degree:]
			new_left.children = new_left.children[:self.min_degree]

	def preorder(self):
		"""
			Imprime as chaves de cada nó da árvore.
		"""
		self._preorder(self.root)

	def _preorder(self, node):
		"""
			Imprime as chaves de cada nó da árvore recursivamente, na sequência: raiz,
			esquerda, direita.

			node: raiz da árvore ou subárvore.
		"""
		if node.is_leaf:
			print(node.keys)

		else:
			print(node.keys)

			for child in node.children:
				self._preorder(child)

	def inorder(self):
		"""
			Retorna uma lista com os valores ordenados das chaves presentes na árvore B.
		"""

		self._inorder(self.root, [])

	def _inorder(self, node, values):
		if node is not None:


	def get_all_values_less_than(self, k):
		"""
			Retorna todos os valores menores que k, ordenados em ordem crescente.

			k: upper bound dos valores.
		"""
		return [x for x in self.inorder() if x < k]


tree = BTree(3)

tree.insert(8)
tree.insert(56)
tree.insert(30)
tree.insert(57)
tree.insert(58)
tree.insert(60)
tree.insert(55)
tree.insert(59)
tree.insert(61)
tree.insert(10)
tree.insert(17)
tree.preorder()

tree.search(8, tree.root)
tree.search(61)
tree.search(90)  				# Esperado: Not Found
print(tree.get_all_values_less_than(40))

tree2 = BTree(3)
tree2.operation_values(tree2.insert, [8, 56, 30, 57, 58, 60])
tree2.preorder()
tree2.operation_values(tree2.search, [8, 58, 30, 900]) # Esperado: [8, 58, 30, Not Found]
