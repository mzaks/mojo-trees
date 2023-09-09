from testing import *
from fiby_tree import FibyTree

fn int_eq(a: Int, b: Int) -> Bool:
    return a == b

fn int_cmp(a: Int, b: Int) -> Int:
    return a - b

fn int_to_str(a: Int) -> String:
    return String(a)

fn assert_vec(a: UnsafeFixedVector[Int], b: UnsafeFixedVector[Int]):
    if assert_equal(len(a), len(b)):
        for i in range(len(a)):
            _ = assert_equal(a[i], b[i])
    else:
        print("Length", len(a), "is not equal to", len(b))

fn vec[T: AnyType](*elements: T) -> UnsafeFixedVector[T]:
    let elements_list: VariadicList[T] = elements
    var result = UnsafeFixedVector[T](len(elements_list))
    for i in range(len(elements_list)):
        result.append(elements[i])
    return result

fn fiby(*elements: Int) -> FibyTree[Int, int_cmp, int_to_str]:
    let elements_list: VariadicList[Int] = elements
    var tree = FibyTree[Int, int_cmp, int_to_str]()
    for i in range(len(elements_list)):
        tree.add(elements[i])
    return tree^

fn assert_tree(tree: FibyTree[Int, int_cmp, int_to_str], count: Int, max_depth: Int):
    if not assert_equal(tree.__len__(), count):
        print("Length assertion failed")
    if not assert_equal(tree.max_depth, max_depth):
        print("depth assertion failed")



fn test_start_with_empty_tree():
    var bst = fiby()
    assert_tree(bst, 0, 0)
    bst.add(13)
    assert_tree(bst, 1, 1)
    bst.add(15)
    assert_tree(bst, 2, 2)
    _= assert_true(bst.delete(13))
    assert_tree(bst, 1, 2)
    _= assert_true(bst.delete(15))
    assert_tree(bst, 0, 2)
    _= assert_false(bst.__contains__(15))
    bst.balance()
    assert_tree(bst, 0, 0)

fn test_longer_sequence_dedup_and_balance():    
    var bst = fiby(5, 6, 3, 8, 11, 34, 56, 12, 48, 11, 9)
    assert_vec(bst.sorted_elements(), vec(3, 5, 6, 8, 9, 11, 12, 34, 48, 56))
    assert_tree(bst, 10, 7)
    bst.balance()
    assert_tree(bst, 10, 4)
    _= assert_true(bst.delete(8))
    assert_vec(bst.sorted_elements(), vec(3, 5, 6, 9, 11, 12, 34, 48, 56))
    assert_tree(bst, 9, 4)
    
    let elements = bst.sorted_elements()
    for i in range(len(elements)):
        _= assert_true(bst.delete(elements[i]))

    assert_tree(bst, 0, 4)
    bst.add(13)
    assert_tree(bst, 1, 4)
    bst.clear()
    assert_tree(bst, 0, 0)
    
    
fn test_add_ascending():
    var bst = fiby()
    for i in range(10):
        bst.add(i)
    assert_vec(bst.sorted_elements(), vec(0, 1, 2, 3, 4, 5, 6, 7, 8, 9))
    assert_tree(bst, 10, 10)
    bst.balance()
    assert_tree(bst, 10, 4)
    for i in range(10):
        _= assert_true(bst.__contains__(i))
        
fn test_union_inplace():
    var b1 = fiby(1, 2, 3)
    b1.union_inplace(fiby())
    assert_vec(b1.sorted_elements(), vec(1, 2, 3))
    
    var b2 = fiby()
    b2.union_inplace(b1)
    assert_vec(b2.sorted_elements(), vec(1, 2, 3))
    
    b1.union_inplace(fiby(3, 4, 1))
    assert_vec(b1.sorted_elements(), vec(1, 2, 3, 4))
    
    b1.union_inplace(fiby(2, 3))
    assert_vec(b1.sorted_elements(), vec(1, 2, 3, 4))
    
    b1.union_inplace(fiby(9, 12, 11, 10))
    assert_vec(b1.sorted_elements(), vec(1, 2, 3, 4, 9, 10, 11, 12))
    
    b2 = fiby(1)
    b2.union_inplace(fiby(1))
    assert_vec(b2.sorted_elements(), vec(1))
    
    b2.union_inplace(fiby(2))
    assert_vec(b2.sorted_elements(), vec(1, 2))
    
    b2 = fiby(2)
    b2.union_inplace(fiby(1))
    assert_vec(b2.sorted_elements(), vec(1, 2))

fn test_union():
    var b1 = fiby(1, 2, 3)
    var b3 = b1.union(fiby())
    assert_vec(b3.sorted_elements(), vec(1, 2, 3))
    
    var b2 = fiby()
    b3 = b2.union(b1)
    assert_vec(b3.sorted_elements(), vec(1, 2, 3))
    
    b3 = b1.union(fiby(3, 4, 1))
    assert_vec(b3.sorted_elements(), vec(1, 2, 3, 4))
    
    b3 = b1.union(fiby(2, 3))
    assert_vec(b3.sorted_elements(), vec(1, 2, 3, 4))
    
    b3 = b1.union(fiby(9, 12, 11, 10))
    assert_vec(b3.sorted_elements(), vec(1, 2, 3, 4, 9, 10, 11, 12))
    
    b2 = fiby(1)
    b3 = b2.union(fiby(1))
    assert_vec(b3.sorted_elements(), vec(1))
    
    b2.union_inplace(fiby(2))
    assert_vec(b2.sorted_elements(), vec(1, 2))
    
    b2 = fiby(2)
    b2.union_inplace(fiby(1))
    assert_vec(b2.sorted_elements(), vec(1, 2))

    
fn test_intersection_inplace():
    var b1 = fiby(1, 2, 3)
    b1.intersection_inplace(fiby(3, 4, 1, 6, 7, 10))
    assert_vec(b1.sorted_elements(), vec(1, 3))
    
    b1.intersection_inplace(fiby())
    assert_vec(b1.sorted_elements(), vec[Int]())
    
    b1.intersection_inplace(fiby(3, 4, 1))
    assert_vec(b1.sorted_elements(), vec[Int]())
    
    var b2 = fiby(3, 4, 1, 6, 7, 10)
    b2.intersection_inplace(fiby(1, 2, 3, 8))
    assert_vec(b2.sorted_elements(), vec(1, 3))
    
    b2 = fiby(1)
    b2.intersection_inplace(fiby(1))
    assert_vec(b2.sorted_elements(), vec(1))
    
    b2 = fiby(1)
    b2.intersection_inplace(fiby(2))
    assert_vec(b2.sorted_elements(), vec[Int]())
    
    b2 = fiby(2)
    b2.intersection_inplace(fiby(1))
    assert_vec(b2.sorted_elements(), vec[Int]())

fn test_difference_inplace():
    var b1 = fiby(1, 2, 3)
    b1.difference_inplace(fiby(5, 6, 7, 1))
    assert_vec(b1.sorted_elements(), vec(2, 3))
    b1.difference_inplace(fiby())
    assert_vec(b1.sorted_elements(), vec(2, 3))
    b1.difference_inplace(fiby(1, 12, 34))
    assert_vec(b1.sorted_elements(), vec(2, 3))
    
    var b2 = fiby()
    b2.difference_inplace(fiby(1, 2, 3))
    assert_tree(b2, 0, 0)
    
    b2 = fiby(1)
    b2.difference_inplace(fiby(1))
    assert_vec(b2.sorted_elements(), vec[Int]())
    
    b2 = fiby(1)
    b2.difference_inplace(fiby(2))
    assert_vec(b2.sorted_elements(), vec(1))
    
    b2 = fiby(2)
    b2.difference_inplace(fiby(1))
    assert_vec(b2.sorted_elements(), vec(2))
        
fn test_other_difference_inplace():
    var b1 = fiby(1, 2, 3)
    b1.other_difference_inplace(fiby(5, 6, 7, 1))
    assert_vec(b1.sorted_elements(), vec(5, 6, 7))
    b1.other_difference_inplace(fiby())
    assert_vec(b1.sorted_elements(), vec[Int]())
    
    b1 = fiby(1, 2, 3)
    b1.other_difference_inplace(fiby(0, 1, 12, 34))
    assert_vec(b1.sorted_elements(), vec(0, 12, 34))
    
    var b2 = fiby()
    b2.other_difference_inplace(fiby(1, 2, 3))
    assert_vec(b2.sorted_elements(), vec(1, 2, 3))
    
    b2 = fiby(1)
    b2.other_difference_inplace(fiby(1))
    assert_vec(b2.sorted_elements(), vec[Int]())
    
    b2 = fiby(1)
    b2.other_difference_inplace(fiby(2))
    assert_vec(b2.sorted_elements(), vec(2))
    
    b2 = fiby(2)
    b2.other_difference_inplace(fiby(1))
    assert_vec(b2.sorted_elements(), vec(1))
    
fn test_symmetric_difference_inplace():
    var b1 = fiby(1, 2, 3)
    b1.symmetric_difference_inplace(fiby(3, 4, 5))
    assert_vec(b1.sorted_elements(), vec(1, 2, 4, 5))
    
    b1.symmetric_difference_inplace(fiby(0, 2, 8, 5, 13))
    assert_vec(b1.sorted_elements(), vec(0, 1, 4, 8, 13))
    
    b1.symmetric_difference_inplace(fiby())
    assert_vec(b1.sorted_elements(), vec(0, 1, 4, 8, 13))
    
    var b2 = fiby()
    b2.symmetric_difference_inplace(fiby(1, 2, 3))
    assert_vec(b2.sorted_elements(), vec(1, 2, 3))
    
    b2 = fiby()
    b2.symmetric_difference_inplace(fiby(1))
    assert_vec(b2.sorted_elements(), vec(1))
    
    b2 = fiby(1)
    b2.symmetric_difference_inplace(fiby())
    assert_vec(b2.sorted_elements(), vec(1))
    
    b2 = fiby(1)
    b2.symmetric_difference_inplace(fiby(1))
    assert_vec(b2.sorted_elements(), vec[Int]())
    
    b2 = fiby(1)
    b2.symmetric_difference_inplace(fiby(2))
    assert_vec(b2.sorted_elements(), vec(1, 2))
    
    b2 = fiby(2)
    b2.symmetric_difference_inplace(fiby(1))
    assert_vec(b2.sorted_elements(), vec(1, 2))
        
fn test_disjoint():
    _= assert_true(fiby().is_disjoint(fiby()))
    _= assert_true(fiby().is_disjoint(fiby(1)))
    _= assert_true(fiby(1).is_disjoint(fiby()))
    _= assert_true(fiby(1).is_disjoint(fiby(2)))
    _= assert_false(fiby(1).is_disjoint(fiby(1)))
    _= assert_true(fiby(1, 3).is_disjoint(fiby(2, 5, 6)))
    _= assert_true(fiby(1, 3, 5).is_disjoint(fiby(2, 0, 7)))
    _= assert_false(fiby(1, 3, 5).is_disjoint(fiby(2, 5)))
    _= assert_false(fiby(1, 5).is_disjoint(fiby(2, 5)))

fn test_subset():
    _= assert_true(fiby().is_subset(fiby()))
    _= assert_true(fiby().is_subset(fiby(1, 2, 3)))
    _= assert_true(fiby(3).is_subset(fiby(3)))
    _= assert_true(fiby(3).is_subset(fiby(1, 2, 3)))
    _= assert_true(fiby(3, 1).is_subset(fiby(1, 2, 3)))
    _= assert_true(fiby(3, 1, 2).is_subset(fiby(1, 2, 3)))
    _= assert_false(fiby(1).is_subset(fiby(3)))
    _= assert_false(fiby(3, 1, 2, 5).is_subset(fiby(1, 2, 3)))
    _= assert_false(fiby(3, 1, 5).is_subset(fiby(1, 2, 3)))
    
fn test_superset():
    _= assert_false(fiby(1).is_superset(fiby(2)))
    _= assert_false(fiby(1, 5, 8).is_superset(fiby(1, 5, 8, 9)))
    _= assert_false(fiby(1, 5, 8).is_superset(fiby(1, 5, 9)))
    
    _= assert_true(fiby().is_superset(fiby()))
    _= assert_true(fiby(1).is_superset(fiby(1)))
    _= assert_true(fiby(1, 5, 8, 9).is_superset(fiby(1, 5, 8, 9)))
    _= assert_true(fiby(1, 5, 8, 9).is_superset(fiby(1, 5, 8)))
    _= assert_true(fiby(0, 1, 5, 8, 9).is_superset(fiby(1, 5, 8)))

fn test_min_index():
    _= assert_equal(fiby().min_index(), -1)
    _= assert_equal(fiby(1).min_index(), 0)
    _= assert_equal(fiby(1, 2, 3, 4).min_index(), 0)
    _= assert_equal(fiby(3, 4, 1, 2).min_index(), 2)
    var f = fiby(3, 4, 1, 2)
    f.balance()
    _= assert_equal(f.min_index(), 3)
    
    f = fiby(1, 3, 2, 4, 5)
    _= assert_equal(f.min_index(), 0)
    f = fiby(3, 1, 2, 4, 5)
    _= assert_equal(f.min_index(), 1)
    f = fiby(3, 2, 1, 4, 5)
    _= assert_equal(f.min_index(), 2)
    f = fiby(3, 2, 4, 1, 5)
    _= assert_equal(f.min_index(), 3)
    f = fiby(3, 2, 4, 5, 1)
    _= assert_equal(f.min_index(), 4)
    
    f = fiby(1, 3, 2, 4, 5)
    f.balance()
    _= assert_equal(f.min_index(), 3)
    f = fiby(3, 1, 2, 4, 5)
    f.balance()
    _= assert_equal(f.min_index(), 3)
    f = fiby(3, 2, 1, 4, 5)
    f.balance()
    _= assert_equal(f.min_index(), 3)
    f = fiby(3, 2, 4, 1, 5)
    f.balance()
    _= assert_equal(f.min_index(), 3)
    f = fiby(3, 2, 4, 5, 1)
    f.balance()
    _= assert_equal(f.min_index(), 3)
    
fn test_max_index():
    _= assert_equal(fiby().max_index(), -1)
    _= assert_equal(fiby(1).max_index(), 0)
    _= assert_equal(fiby(1, 2, 3, 4).max_index(), 3)
    _= assert_equal(fiby(3, 4, 1, 2).max_index(), 1)
    var f = fiby(3, 4, 1, 2)
    f.balance()
    _= assert_equal(f.max_index(), 2)
    
    f = fiby(3, 4, 1, 2, 5, 6, 0)
    f.balance()
    _= assert_equal(f.max_index(), 6)
    _= assert_equal(f.elements[6], 6)
    
    f = fiby(1, 3, 2, 4, 5)
    _= assert_equal(f.max_index(), 4)
    f = fiby(3, 1, 2, 5, 4)
    _= assert_equal(f.max_index(), 3)
    f = fiby(3, 2, 5, 4, 1)
    _= assert_equal(f.max_index(), 2)
    f = fiby(3, 5, 4, 1, 2)
    _= assert_equal(f.max_index(), 1)
    f = fiby(5, 2, 4, 5, 3)
    _= assert_equal(f.max_index(), 0)
    
    f = fiby(1, 3, 2, 4, 5)
    f.balance()
    _= assert_equal(f.max_index(), 2)
    f = fiby(3, 1, 2, 5, 4)
    f.balance()
    _= assert_equal(f.max_index(), 2)
    f = fiby(3, 2, 5, 4, 1)
    f.balance()
    _= assert_equal(f.max_index(), 2)
    f = fiby(3, 5, 4, 1, 2)
    f.balance()
    _= assert_equal(f.max_index(), 2)
    f = fiby(5, 2, 4, 5, 3)
    f.balance()
    _= assert_equal(f.max_index(), 2)
    _= assert_equal(f.elements[2], 5)

fn main():
    test_start_with_empty_tree()
    test_longer_sequence_dedup_and_balance()
    test_add_ascending()
    test_union_inplace()
    test_intersection_inplace()
    test_difference_inplace()
    test_other_difference_inplace()
    test_symmetric_difference_inplace()
    # Uncomment once https://github.com/modularml/mojo/issues/500 is shipped
    # test_union()
    test_disjoint()
    test_subset()
    test_superset()
    test_min_index()
    test_max_index()

    print("SUCCESS!!!")