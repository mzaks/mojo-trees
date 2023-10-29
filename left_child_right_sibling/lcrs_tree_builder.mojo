from .lcrs_tree import LCRSTree

struct LCRSTreeBuilder[T: AnyType]:
    var _tree: LCRSTree[T]
    var _queue: DynamicVector[UInt16]
    
    fn __init__(inout self, root: T):
        self._tree = LCRSTree(root)
        self._queue = DynamicVector[UInt16]()
        self._queue.push_back(0)
    
    fn __moveinit__(inout self, owned existing: Self):
        self._tree = existing._tree^
        self._queue = existing._queue
    
    fn node(owned self, node: T) -> LCRSTreeBuilder[T]:
        let last = self._queue[len(self._queue) - 1]
        self._queue.push_back(self._tree.add_child(node, last))
        return self^
    
    fn leaf(owned self, node: T) -> LCRSTreeBuilder[T]:
        let last = self._queue[len(self._queue) - 1]
        _ = self._tree.add_child(node, last)
        return self^
    
    fn up(owned self) -> LCRSTreeBuilder[T]:
        _ = self._queue.pop_back()
        return self^
    
    fn tree(owned self) -> LCRSTree[T]:
        return self._tree^