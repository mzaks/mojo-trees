from utils.vector import DynamicVector, UnsafeFixedVector

struct LCRSTree[T: AnyType]:
    var elements: DynamicVector[T]
    var left_child: DynamicVector[UInt16]
    var right_sibling: DynamicVector[UInt16]
    var parent: DynamicVector[UInt16]
    var deleted: DynamicVector[UInt16]
    
    fn __init__(inout self, root: T):
        self.elements = DynamicVector[T]()
        self.left_child = DynamicVector[UInt16]()
        self.right_sibling = DynamicVector[UInt16]()
        self.parent = DynamicVector[UInt16]()
        self.deleted = DynamicVector[UInt16]()
        self.elements.push_back(root)
        self.left_child.push_back(0)
        self.right_sibling.push_back(0)
        self.parent.push_back(0)
        
    fn __moveinit__(inout self, owned existing: Self):
        self.elements = existing.elements
        self.left_child = existing.left_child
        self.right_sibling = existing.right_sibling
        self.parent = existing.parent
        self.deleted = existing.deleted
    
    fn add_child(inout self, node: T, parent_index: UInt16 = 0) -> UInt16:
        var node_index = len(self.elements)
        if len(self.deleted) == 0:
            self.elements.push_back(node)
            self.left_child.push_back(node_index)
            self.right_sibling.push_back(node_index)
            self.parent.push_back(parent_index)
        else:
            node_index = self.deleted.pop_back().to_int()
            self.elements[node_index] = node
            self.left_child[node_index] = node_index
            self.right_sibling[node_index] = node_index
            self.parent[node_index] = parent_index
        
        self._add_as_last_child(parent_index, node_index)
        return node_index
    
    fn add_tree(inout self, tree: Self, parent_index: UInt16 = 0) -> UInt16:
        let new_root = len(self.elements)
        for i in range(len(tree.elements)):
            self.elements.push_back(tree.elements[i])
            self.left_child.push_back(tree.left_child[i] + new_root)
            self.right_sibling.push_back(tree.right_sibling[i] + new_root)
            self.parent.push_back(tree.parent[i] + new_root)
        
        self.parent[new_root] = 0

        for i in range(len(tree.deleted)):
            self.deleted.push_back(tree.deleted[i] + new_root)
        
        self._add_as_last_child(parent_index, new_root)
        return new_root
    
    fn _add_as_last_child(inout self, parent_index: UInt16, node_index: UInt16):
        var current_child = self.left_child[parent_index.to_int()]
        if current_child == parent_index:
            self.left_child[parent_index.to_int()] = node_index
        else:
            var right_sibling = self.right_sibling[current_child.to_int()]
            while right_sibling != current_child:
                current_child = right_sibling
                right_sibling = self.right_sibling[current_child.to_int()]
            self.right_sibling[current_child.to_int()] = node_index
    
    fn prepend_root(inout self, element: T) -> UInt16:
        var old_parent_index = len(self.elements)
        
        if len(self.deleted) == 0:
            self.elements.push_back(self.elements[0])
            self.left_child.push_back(self.left_child[0])
            self.right_sibling.push_back(old_parent_index)
            self.parent.push_back(0)
        else:
            old_parent_index = self.deleted.pop_back().to_int()
            self.elements[old_parent_index] = self.elements[0]
            self.left_child[old_parent_index] = self.left_child[0]
            self.right_sibling[old_parent_index] = old_parent_index
            self.parent[old_parent_index] = 0
        
        self.elements[0] = element
        self.left_child[0] = old_parent_index
        
        var child = self.left_child[old_parent_index]
        self.parent[child.to_int()] = old_parent_index
        while self.right_sibling[child.to_int()] != child:
            child = self.right_sibling[child.to_int()]
            self.parent[child.to_int()] = old_parent_index
        
        return old_parent_index
            
    fn __getitem__(self, node_index: UInt16) -> T:
        return self.elements[node_index.to_int()]
    
    fn __setitem__(inout self, node_index: UInt16, element: T):
        self.elements[node_index.to_int()] = element
        
    fn __len__(self: Self) -> Int:
        return len(self.elements) - len(self.deleted)
        
    fn swap_elements(inout self, index_a: UInt16, index_b: UInt16):
        let temp = self.elements[index_a.to_int()]
        self.elements[index_a.to_int()] = self.elements[index_b.to_int()]
        self.elements[index_b.to_int()] = temp
        
    fn swap_nodes(inout self, index_a: UInt16, index_b: UInt16) -> Bool:
        if index_a == index_b:
            return False
        if self.is_leaf(index_a) and self.is_leaf(index_b):
            self.swap_elements(index_a, index_b)
            return True
        if self.are_siblings(index_a, index_b):
            self._swap_siblings(index_a, index_b)
            return True
        if not self.is_root(index_a) and not self.is_root(index_b):
            self._swap_nodes(index_a, index_b)
        return False
    
    fn is_leaf(self, index: UInt16) -> Bool:
        return (self.left_child[index.to_int()] == index).__bool__()
    
    fn is_root(self, index: UInt16) -> Bool:
        return (self.parent[index.to_int()] == index).__bool__()
    
    fn are_siblings(self, index_a: UInt16, index_b: UInt16) -> Bool:
        return (self.parent[index_a.to_int()] == self.parent[index_b.to_int()]).__bool__()
    
    fn _swap_siblings(inout self, index_a: UInt16, index_b: UInt16):
        let parent = self.parent[index_a.to_int()]
        
        let children = self.children_indices(parent)
        var children_index_left = -1
        var children_index_right = -1
        for i in range(len(children)):
            if children[i] == index_a or children[i] == index_b:
                if children_index_left == -1:
                    children_index_left = i
                else:    
                    children_index_right = i
                    break
        
        let left_sibling = children[children_index_left]
        let right_sibling = children[children_index_right]
        let left_sibling_of_right = children[children_index_right - 1]
        
        if children_index_left == 0:
            self.left_child[parent.to_int()] = right_sibling
        
        let prev_right_sibling_of_left = self.right_sibling[left_sibling.to_int()]
        if children_index_right == len(children) - 1:
            self.right_sibling[left_sibling.to_int()] = left_sibling
        else:
            self.right_sibling[left_sibling.to_int()] = self.right_sibling[right_sibling.to_int()]
        
        if left_sibling == left_sibling_of_right:
            self.right_sibling[right_sibling.to_int()] = left_sibling
        else:
            self.right_sibling[right_sibling.to_int()] = prev_right_sibling_of_left
            self.right_sibling[left_sibling_of_right.to_int()] = left_sibling
            
    fn _swap_nodes(inout self, index_a: UInt16, index_b: UInt16):
        let parent_a = self.parent[index_a.to_int()]
        let parent_b = self.parent[index_b.to_int()]
        
        self.parent[index_a.to_int()] = parent_b
        self.parent[index_b.to_int()] = parent_a
        
        let right_sibling_a = self.right_sibling[index_a.to_int()]
        let right_sibling_b = self.right_sibling[index_b.to_int()]
        
        if self.left_child[parent_a.to_int()] == index_a:
            self.left_child[parent_a.to_int()] = index_b
        else:
            var left_sibling = self.left_child[parent_a.to_int()]
            while self.right_sibling[left_sibling.to_int()] != index_a:
                left_sibling = self.right_sibling[left_sibling.to_int()]
            self.right_sibling[left_sibling.to_int()] = index_b

        if self.left_child[parent_b.to_int()] == index_b:
            self.left_child[parent_b.to_int()] = index_a
        else:
            var left_sibling = self.left_child[parent_b.to_int()]
            while self.right_sibling[left_sibling.to_int()] != index_b:
                left_sibling = self.right_sibling[left_sibling.to_int()]
            self.right_sibling[left_sibling.to_int()] = index_a
        
        if right_sibling_a != index_a:
            self.right_sibling[index_b.to_int()] = right_sibling_a
        else:
            self.right_sibling[index_b.to_int()] = index_b
        
        if right_sibling_b != index_b:
            self.right_sibling[index_a.to_int()] = right_sibling_b
        else:
            self.right_sibling[index_a.to_int()] = index_a
         
    fn children_indices(self, parent_index: UInt16) -> DynamicVector[UInt16]:
        var result = DynamicVector[UInt16]()
        var current_child = self.left_child[parent_index.to_int()]
        if current_child == parent_index:
            return result
        result.push_back(current_child)
        var right_sibling = self.right_sibling[current_child.to_int()]
        while right_sibling != current_child:
            result.push_back(right_sibling)
            current_child = right_sibling
            right_sibling = self.right_sibling[current_child.to_int()]
        return result
    
    fn children_count(self, parent_index: UInt16) -> Int:
        var result = 0
        var current_child = self.left_child[parent_index.to_int()]
        if current_child == parent_index:
            return result
        result += 1
        var right_sibling = self.right_sibling[current_child.to_int()]
        while right_sibling != current_child:
            result += 1
            current_child = right_sibling
            right_sibling = self.right_sibling[current_child.to_int()]
        return result
    
    fn ancestor_indices(self, child_index: UInt16) -> DynamicVector[UInt16]:
        var result = DynamicVector[UInt16]()
        var ancestor = child_index
        while ancestor != self.parent[ancestor.to_int()]:
            ancestor = self.parent[ancestor.to_int()]
            result.push_back(ancestor)
        return result
    
    fn get_dfs_indices(self, root: UInt16 = 0) -> DynamicVector[UInt16]:
        var result = DynamicVector[UInt16]()
        if len(self.elements) <= root.to_int():
            return result
        result.push_back(root)
        self._dfs(root, result)
        return result
        
    fn _dfs(self, index: UInt16, inout result: DynamicVector[UInt16]):
        let child = self.left_child[index.to_int()]
        if child == index:
            let sibling = self.right_sibling[index.to_int()]
            if sibling == index:
                return
            result.push_back(sibling)
            self._dfs(sibling, result)
        else:
            result.push_back(child)
            self._dfs(child, result)
            let sibling = self.right_sibling[index.to_int()]
            if sibling == index:
                return
            result.push_back(sibling)
            self._dfs(sibling, result)
            
    fn traverse_dfs[visitor: fn(UInt16, T) -> Bool](self, root: UInt16 = 0) -> None:
        if len(self.elements) > root.to_int():
            self._traverse_dfs[visitor](root, True)
        
    fn _traverse_dfs[visitor: fn(UInt16, T) -> Bool](self, index: UInt16, root: Bool = False) -> None:
        if visitor(index, self.elements[index.to_int()]):
            let child = self.left_child[index.to_int()]
            if child == index:
                if root:
                    return
                let sibling = self.right_sibling[index.to_int()]
                if sibling == index:
                    return
                self._traverse_dfs[visitor](sibling)
            else:
                self._traverse_dfs[visitor](child)
                let sibling = self.right_sibling[index.to_int()]
                if sibling == index:
                    return
                self._traverse_dfs[visitor](sibling)
    
    fn get_bfs_indices(self, root: UInt16 = 0) -> DynamicVector[UInt16]:
        var result = DynamicVector[UInt16]()
        if len(self.elements) <= root.to_int():
            return result
        result.push_back(root)
        var visited = 0
        while len(result) > visited:
            let index = result[visited]
            var child = self.left_child[result[visited].to_int()]
            if child != index:
                result.push_back(child)
                var sibling = self.right_sibling[child.to_int()]
                while sibling != child:
                    result.push_back(sibling)
                    child = sibling
                    sibling = self.right_sibling[child.to_int()]
            visited += 1
        return result
    
    fn traverse_bfs[visitor: fn(UInt16, T) -> Bool](self, root: UInt16 = 0) -> None:
        if len(self.elements) <= root.to_int():
            return
        if visitor(root, self.elements[root.to_int()]):
            var visited = 0
            # Could be implemented with stack allocated pointer
            var result = UnsafeFixedVector[UInt16](len(self.elements))
            result.append(root)
            while len(result) > visited:
                let index = result[visited]
                var child = self.left_child[result[visited].to_int()]
                if child != index:
                    result.append(child)
                    if not visitor(child, self.elements[child.to_int()]):
                        return
                    var sibling = self.right_sibling[child.to_int()]
                    while sibling != child:
                        result.append(sibling)
                        if not visitor(sibling, self.elements[sibling.to_int()]):
                            return
                        child = sibling
                        sibling = self.right_sibling[child.to_int()]
                visited += 1
            
    fn remove(inout self, index: UInt16):
        if index == 0:
            self.elements.clear()
            self.left_child.clear()
            self.right_sibling.clear()
            self.parent.clear()
            return
        let parent = self.parent[index.to_int()]
        if parent != index:
            var parent_child = self.left_child[parent.to_int()]
            if parent_child == index:
                if self.right_sibling[index.to_int()] != index:
                    self.left_child[parent.to_int()] = self.right_sibling[index.to_int()]
                else:
                    self.left_child[parent.to_int()] = parent
            else:
                while self.right_sibling[parent_child.to_int()] != index:
                    parent_child = self.right_sibling[parent_child.to_int()]
                if self.right_sibling[index.to_int()] == index:
                    self.right_sibling[parent_child.to_int()] = parent_child
                else:
                    self.right_sibling[parent_child.to_int()] = self.right_sibling[index.to_int()]
        let indecies_to_remove = self.get_bfs_indices(index)
        for i in range(len(indecies_to_remove)):
            self.deleted.push_back(indecies_to_remove[i])
    
    fn compact_dfs(inout self, root_index: UInt16 = 0):
        let indices = self.get_dfs_indices(root_index)
        self._compact(indices)

    fn compact_bfs(inout self, root_index: UInt16 = 0):
        let indices = self.get_bfs_indices(root_index)
        self._compact(indices)
        
    fn _compact(inout self, indices: DynamicVector[UInt16]):
        let old_len = len(self.elements)
        let new_len = len(indices)
        var map = DynamicVector[Int](old_len)
        for i in range(new_len):
            map[indices[i].to_int()] = i
        var new_elements = DynamicVector[T](new_len)
        for i in range(new_len):
            new_elements.push_back(self.elements[indices[i].to_int()])
        self.elements = new_elements
        var new_left_child = DynamicVector[UInt16](new_len)
        for i in range(new_len):
            new_left_child.push_back(map[self.left_child[indices[i].to_int()].to_int()])
        self.left_child = new_left_child
        var new_right_sibling = DynamicVector[UInt16](new_len)
        for i in range(new_len):
            new_right_sibling.push_back(map[self.right_sibling[indices[i].to_int()].to_int()])
        self.right_sibling = new_right_sibling
        var new_parent = DynamicVector[UInt16](new_len)
        for i in range(new_len):
            new_parent.push_back(map[self.parent[indices[i].to_int()].to_int()])
        self.parent = new_parent
        self.deleted.clear()
            
    fn print_tree[to_str: fn(T) -> String](inout self, root: UInt16 = 0):
        self._print[to_str]("", 0)
    
    fn _print[to_str: fn(T) -> String](inout self, indentation: String, index: UInt16):
        if len(indentation) > 10:
            return
        if len(indentation) > 0:
            print(indentation, "-", to_str(self[index.to_int()]))
        else:
            print("-", to_str(self[index.to_int()]))

        let children = self.children_indices(index)
        for i in range(len(children)):
            self._print[to_str](indentation + " ", children[i])
        



fn int_to_str(i: Int) -> String:
    return String(i)

fn int_eq(i1: Int, i2: Int) -> Bool:
    return i1 == i2