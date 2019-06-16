import java.util.OptionalInt;
import java.util.stream.IntStream;

public class BTree<T> {

    private BTree<T> parent;
    private final int order;
    private List<BTree<T>> children;

    private List<T> keys;

    public BTree(final int o) {
        this.o = o;
        this.children = new ArrayList<T>();
        this.keys = new ArrayList<T>();
    }

    boolean isEmpty() {
        return this.children.isEmpty();
    }

    boolean leaf(){
        return this.children.isEmpty();
    }
    
    boolean full(){
        return this.keys.size() == o;
    }

    split(){
        final int mid = this.keys.size() / 2;
        if(parent == null){
            final BTree<T> nParent = new BTree<T>(o);
            nParent.keys.add(this.keys.get(mid));
            final BTree<T> left = new BTree(o);
            left.keys.addAll(keys.sublist(0, mid));
            right.keys.addAll(keys.sublist(mid + 1, keys.size()));
            nParent.children.add(0, left);
            nParent.children.add(1, right);
            return this.parent;
        }
    }

    public BTree<T> insert(T el){
        final int idx = IntStream.range(0, keys.size()).filter(i -> keys.get(i) > el).findFirst().orElse(0).get();
        if(leaf()){
            this.keys.add(idx, el);
            this.children.add(idx, new BTree(o));
            if(full()){
                return split();
            }
        }
    }
}