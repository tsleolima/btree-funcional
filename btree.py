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

	def insert(self, value):
		root = self.root
		# O nó está na capacidade máxima
		if len(root.children) == 2 * self.min_degree - 1:

		else:
			self._insert_not_full(root, value)


	def _insert_not_full(self, node, value):
		i = len(node.children) - 1
		# Se o nó for uma folha e não estiver no limite de sua capacidade, só precisamos
		# inserir a nova chave (value) no array ordenado.
		if x.is_leaf:
			# Fazemos cast pra list() por que em Python3 filter retorna um iterable
			less_than_value = list(filter(lambda x: x < value, node.keys))
			greater_than_value = list(filter(lambda x: x > value, node.keys))
			node.keys = less_than_value + [value] + greater_than_value

		else:



