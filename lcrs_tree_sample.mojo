from left_child_right_sibling import LCRSTree, LCRSTreeBuilder
from helpers import int_to_str

fn v1(i: UInt16, e: Int) -> Bool:
    print(i, e)
    return True

fn main():
    var t = LCRSTree(12)
    let n1 = t.add_child(15)
    let n2 = t.add_child(24)
    let n3 = t.add_child(75)
    _ = t.add_child(88)

    _ = t.add_child(45, n1)
    _ = t.add_child(55, n1)

    _ = t.add_child(590, n2)
    _ = t.add_child(670, n2)

    let all_dfs = t.get_dfs_indices()
    for i in range(len(all_dfs)):
        print(t[all_dfs[i]])

    print("---")    

    let all_bfs = t.get_bfs_indices()
    for i in range(len(all_bfs)):
        print(t[all_bfs[i]])
        
        
    _ = t.swap_nodes(n1, n3)

    print("---")    

    let all_bfs2 = t.get_bfs_indices()
    for i in range(len(all_bfs2)):
        print(t[all_bfs2[i]])


    t.print_tree[int_to_str]()

    _ = t.prepend_root(123)
    _ = t.prepend_root(321)
    t.print_tree[int_to_str]()


    var t2 = LCRSTreeBuilder(1)
                .node(5)
                    .leaf(7)
                    .up()
                .node(10)
                    .node(15)
                        .leaf(13)
                        .leaf(17)
                        .up()
                    .node(45)
            .tree()

    t2.print_tree[int_to_str]()

    _ = t.add_tree(t2)

    t.print_tree[int_to_str]()

    t.traverse_dfs[v1]()

    print("-----")

    t.traverse_bfs[v1]()

    let ancestors = t.ancestor_indices(17)
    print(t[17], len(ancestors))
    for i in range(len(ancestors)):
        print(ancestors[i])

        
    t.compact_dfs()

    print("======")
    t.traverse_dfs[v1]()
    t.print_tree[int_to_str]()

    t.compact_bfs()

    print("======")
    t.traverse_dfs[v1]()
    t.print_tree[int_to_str]()


    print("t len:", t.__len__())
    print("remove node 3")
    t.remove(3)
    print("t len:", t.__len__())
    t.print_tree[int_to_str]()