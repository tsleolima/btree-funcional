package btree;

import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.util.HashSet;
import java.util.LinkedList;

import org.junit.Before;

public class BTreeTest {
	
	BTree<Integer> tree1;
	
	@Before
	public void setUp() {
		tree1 = new BTree<>(4);
	}
	@Test
	public void testDepthLeftOrder() {

		tree1.insert(13);
		tree1.insert(9);
		tree1.insert(5);
	}

	@Test
	public void testInsert2() {

		tree1.insert(13);
		tree1.insert(10);
		tree1.insert(6);

		assertEquals(tree1.getRoot().getElementAt(0), new Integer(6));
		assertEquals(tree1.getRoot().getElementAt(1), new Integer(10));
		assertEquals(tree1.getRoot().getElementAt(2), new Integer(13));

		assertEquals(tree1.size(), 3);
		assertEquals(tree1.height(), 0);

		tree1.insert(12);

		assertEquals(tree1.size(), 4);
		assertEquals(tree1.height(), 1);

		tree1.insert(15);
		tree1.insert(5);

		assertEquals(tree1.size(), 6);
		assertEquals(tree1.height(), 1);
		
		tree1.insert(14);

		tree1.insert(11);
		assertEquals(1, tree1.height());

		tree1.insert(8);
		assertEquals(1, tree1.height());
		tree1.insert(9);
		assertEquals(1, tree1.height());
		
		printTree(tree1);
		tree1.insert(7);
		printTree(tree1);

		tree1.insert(16);
		assertEquals(2, tree1.height());
		printTree(tree1);

		for (int i = 0; i < 4332; i++) {
			tree1.insert(null);
		}

	}

	@Test
	public void testAdd() {
		BTree<Integer> tree = new BTree<>(4);
		assertEquals(tree.size(), 0);

		assertFalse(tree.search(1));
		tree.insert(0);
		tree.insert(1);
		assertTrue(tree.search(1));
		assertFalse(tree.search(-1));
		tree.insert(-1);
		assertTrue(tree.search(-1));

		assertEquals(tree.size(), 3);
		assertEquals(tree.height(), 0);

		tree.insert(2);
		assertEquals(tree.height(), 1);
		tree.insert(-2);
		assertEquals(tree.size(), 5);
		assertEquals(tree.height(), 1);
		assertTrue(tree.search(-2));

		tree.insert(3);
		tree.insert(-3);
		assertEquals(tree.height(), 1);
		assertEquals(tree.size(), 7);

		tree.insert(4);
		assertEquals(tree.height(), 1);
		tree.insert(5);
		tree.insert(6);
		assertEquals(tree.height(), 1);
		tree.insert(7);
		assertEquals(tree.size(), 11);
		assertEquals(tree.height(), 2);
		assertTrue(tree.search(7));
	}

	private void printTree(BTree<?> t) {
		BNode<?> node = t.getRoot();
		class Pair {
			BNode<?> node;
			int c;
			boolean hasLeft;

			Pair(BNode<?> node, int c, boolean hl) {
				this.node = node;
				this.c = -c;
				this.hasLeft = hl;
			}
		}
		;
		LinkedList<Pair> lista = new LinkedList<>();
		HashSet<BNode<?>> visitados = new HashSet<>();

		lista.add(new Pair(node, 1, false));
		int ultimaCor = -1;
		while (!lista.isEmpty()) {
			Pair top = lista.removeFirst();
			if (top.c != ultimaCor)
				System.out.println();

			System.out.print(top.node + (top.hasLeft ? "=" : " "));

			for (BNode<?> b : top.node.getChildren()) {
				if (visitados.add(b))
					lista.addLast(new Pair(b, top.c, !b.equals(top.node.getChildren().getLast())));
			}
			ultimaCor = top.c;
		}
		System.out.println();
	}
}