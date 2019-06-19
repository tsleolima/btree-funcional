package btree;

import java.util.LinkedList;

public class BTree<T extends Comparable<T>> {

	protected BNode<T> root;
	protected int order;

	public BTree(int order) {
		this.order = order;
		this.root = new BNode<T>(order);
	}

	public BNode<T> getRoot() {
		return this.root;
	}

	public boolean isEmpty() {
		return this.root.isEmpty();
	}

	public int height() {
		return height(this.root);
	}

	private int height(BNode<T> node) {
		int result = 0;
		if (!node.isLeaf()) {
			result += 1 + height(node.getChildren().getFirst());
		}
		return result;
	}

	@SuppressWarnings("unchecked")
	public BNode<T>[] depthLeftOrder() {
		LinkedList<BNode<T>> list = new LinkedList<>();
		depthLeftOrder(list, root);
		BNode<T>[] arr = (BNode<T>[]) new BNode[list.size()];
		return list.toArray(arr);
	}

	private void depthLeftOrder(LinkedList<BNode<T>> arr, BNode<T> nodeAt) {
		arr.add(nodeAt);
		for (BNode<T> n : nodeAt.getChildren()) {
			depthLeftOrder(arr, n);
		}
	}

	public int size() {
		return size(root);
	}

	private int size(BNode<T> node) {
		int result = node.size();
		for (BNode<T> n : node.getChildren()) {
			result += size(n);
		}
		return result;
	}

	public boolean search(T element) {
		return search(root, element);
	}

	private boolean search(BNode<T> node, T element) {
		if (node.getElements().size() == 0) {
			return false;
		}
		int indexOf = node.getElements().indexOf(element);
		if (indexOf != -1) {
			return true;
		} else { //olhar outros nós
			if (node.getChildren().size() == 0) {
				return false;
			}
			return search(searchNode(node, element, 0), element);
			
			/*
			for (BNode<T> n : node.getChildren()) {
				boolean aux = search(n, element);
				if (aux) {
					return true;
				}
			}*/
		}
	}
	
	private BNode<T> searchNode(BNode<T> node, T element, int pos) {
		if (node.getElements().get(pos).compareTo(element) > 0) {
			return node.getChildren().get(pos);
		}
		else if (node.size() == pos + 1) {//ultima pos
			return node.getChildren().get(pos+1);
		}
		return searchNode(node, element, pos+1);
	}

	public void insert(T element) {
		if (element != null && !this.search(element)) {
			insert(this.root, element);
		}
	}

	private void insert(BNode<T> node, T element) {
		if (node.isFull()) {
			split(node);
			if (node.getParent() != null)
				node = node.getParent();
		}
		if (node.getChildren().isEmpty()) {
			node.addElement(element);
		} else {
			int i;
			for (i = 0; i < node.size(); i++) {
				T e = node.getElements().get(i);
				if (e.compareTo(element) > 0) {
					insert(node.getChildren().get(i), element);
					break;
				}
			}
			if (i == node.size()) {
				while (node.getChildren().size() <= i) {
					BNode<T> nNode = new BNode<T>(order);
					nNode.setParent(node);
					node.getChildren().add(nNode);
				}
				insert(node.getChildren().get(i), element);
			}
		}
	}

	private void split(BNode<T> node) {
		BNode<T> right = new BNode<>(order);
		BNode<T> left = new BNode<>(order);

		T middle = node.getElements().get((order - 1) / 2);
		boolean addInLeft = true;
		for (T e : node.getElements()) {
			if (e.equals(middle)) {
				addInLeft = false;
			} else if (addInLeft) {
				left.addElement(e);
			} else {
				right.addElement(e);
			}
		}

		if (!node.equals(root)) {
			promote(node, left, right);
		} else {
			for (int i = 0; i < node.getChildren().size(); i++) {
				if (i <= (order-1) / 2) {
					left.addChild(i, node.getChildren().get(i));
				} else {
					right.addChild(i - ((order-1) / 2) - 1, node.getChildren().get(i));
				}
			}
			left.setParent(node);
			right.setParent(node);

			node.getChildren().clear();
			node.addChild(0, left);
			node.addChild(1, right);

			node.getElements().clear();
			node.addElement(middle);
		}
	}

	private void promote(BNode<T> node, BNode<T> leftChild, BNode<T> rightChild) {
		BNode<T> parent = node.getParent();
		T element = node.getElementAt((order - 1) / 2);
		parent.addElement(element);

		int position = parent.getElements().indexOf(element);
		parent.removeChild(node);

		leftChild.setParent(parent);
		rightChild.setParent(parent);

		node.parent.removeChild(node);
		node.parent.addChild(position, rightChild);
		node.parent.addChild(position, leftChild);
	}
	
}