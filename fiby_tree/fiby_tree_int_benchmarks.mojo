from fiby_tree import FibyTree
from time import now
from random import random_si64

fn cmp_int(a: Int, b: Int) -> Int:
    return a - b

fn its(a: Int) -> String:
    return String(a)

fn fiby() -> FibyTree[Int, cmp_int, its]:
    return FibyTree[Int, cmp_int, its]()

fn perf_test_random_add(size: Int, min: Int = -30000, max: Int = 30000) -> Float64:
    var total = 0
    
    var tik = now()
    var tok = now()
    var f = fiby()
    
    for _ in range(size):
        let i = random_si64(min, max).to_int()
        tik = now()
        f.add(i)
        tok = now()
        total += (tok - tik)
    
    return total / size
    
fn perf_test_ordered_add(size: Int) -> Float64:
    var total = 0
    var tik = now()
    var f = fiby()
    var tok = now()
    total += tok - tik
    for i in range(size):
        tik = now()
        f.add(i)
        tok = now()
        total += (tok - tik)
        
    total += (tok - tik)
    
    return total / size


fn perf_test_contains(size: Int, balanced: Bool, inout found: Int) -> Float64:
    var f = fiby()
    for _ in range(size):
        let i = random_si64(-size, size).to_int()
        f.add(i)

    if balanced:
        f.balance()
    
    var total = 0
    
    var tik = now()
    var tok = now()

    var res = DynamicVector[Bool](size)
    for i in range(size):
        tik = now()
        let r = f.__contains__(i)
        tok = now()
        res.push_back(r)
        total += (tok - tik)

    var count = 0
    for i in  range(len(res)):
        if res[i]:
            count += 1
    found = count
    
    return total / size

fn perf_test_delete(size: Int, balanced: Bool, inout found: Int) -> Float64:
    var f = fiby()
    for _ in range(size):
        let i = random_si64(-size, size).to_int()
        f.add(i)

    if balanced:
        f.balance()
    
    var total = 0
    
    var tik = now()
    var tok = now()

    var res = DynamicVector[Bool](size)
    for i in range(size):
        tik = now()
        let r = f.delete(i)
        tok = now()
        res.push_back(r)
        total += (tok - tik)
    
    var count = 0
    for i in  range(len(res)):
        if res[i]:
            count += 1
    found = count
    
    return total / size

fn perf_test_union(size: Int, balanced: Bool) -> Float64:
    var f1 = fiby()
    var f2 = fiby()
    for _ in range(size):
        let i = random_si64(-size, size).to_int()
        f1.add(i)
        f2.add(i)
    if balanced:
        f1.balance()
        f2.balance()
    
    let tik = now()
    f1.union_inplace(f2)
    let tok = now()
    
    return (tok - tik) / Float64(size)

fn perf_test_intersection(size: Int, balanced: Bool) -> Float64:
    var f1 = fiby()
    var f2 = fiby()
    for _ in range(size):
        let i = random_si64(-size, size).to_int()
        f1.add(i)
        f2.add(i)

    if balanced:
        f1.balance()
        f2.balance()
    
    let tik = now()
    f1.intersection_inplace(f2)
    let tok = now()
    
    return (tok - tik) / Float64(size)

fn perf_test_difference(size: Int, balanced: Bool) -> Float64:
    var f1 = fiby()
    var f2 = fiby()
    for _ in range(size):
        let i = random_si64(-size, size).to_int()
        f1.add(i)
        f2.add(i)
    if balanced:
        f1.balance()
        f2.balance()
    
    let tik = now()
    f1.difference_inplace(f2)
    let tok = now()
    
    return (tok - tik) / Float64(size)

fn perf_test_symmetric_difference(size: Int, balanced: Bool) -> Float64:
    var f1 = fiby()
    var f2 = fiby()
    for _ in range(size):
        let i = random_si64(-size, size).to_int()
        f1.add(i)
        f2.add(i)
    if balanced:
        f1.balance()
        f2.balance()
    
    let tik = now()
    f1.symmetric_difference_inplace(f2)
    let tok = now()
    
    return (tok - tik) / Float64(size)

fn main():
    print("===Random Add===")
    print(perf_test_random_add(10))
    print(perf_test_random_add(100))
    print(perf_test_random_add(300))
    print(perf_test_random_add(500))
    print(perf_test_random_add(1_000))
    print(perf_test_random_add(3_000))
    print(perf_test_random_add(9_000))
    print(perf_test_random_add(15_000))
    print(perf_test_random_add(30_000))
    print(perf_test_random_add(50_000))

    print("===Ordered Add===")

    print(perf_test_ordered_add(10))
    print(perf_test_ordered_add(100))
    print(perf_test_ordered_add(300))
    print(perf_test_ordered_add(500))
    print(perf_test_ordered_add(1_000))
    print(perf_test_ordered_add(3_000))
    print(perf_test_ordered_add(9_000))
    print(perf_test_ordered_add(15_000))
    print(perf_test_ordered_add(30_000))
    print(perf_test_ordered_add(50_000))

    var r = 0

    print("===Contains===")
    print(perf_test_contains(10, False, r))
    print(perf_test_contains(100, False, r))
    print(perf_test_contains(300, False, r))
    print(perf_test_contains(500, False, r))
    print(perf_test_contains(1_000, False, r))
    print(perf_test_contains(3_000, False, r))
    print(perf_test_contains(9_000, False, r))
    print(perf_test_contains(15_000, False, r))
    print(perf_test_contains(30_000, False, r))
    print(perf_test_contains(50_000, False, r))

    print("===Contains Balanced===")
    print(perf_test_contains(10, True, r))
    print(perf_test_contains(300, True, r))
    print(perf_test_contains(100, True, r))
    print(perf_test_contains(500, True, r))
    print(perf_test_contains(1_000, True, r))
    print(perf_test_contains(3_000, True, r))
    print(perf_test_contains(9_000, True, r))
    print(perf_test_contains(15_000, True, r))
    print(perf_test_contains(30_000, True, r))
    print(perf_test_contains(50_000, True, r))

    print("===Delete===")
    print(perf_test_delete(10, False, r))
    print(perf_test_delete(100, False, r))
    print(perf_test_delete(300, False, r))
    print(perf_test_delete(500, False, r))
    print(perf_test_delete(1_000, False, r))
    print(perf_test_delete(3_000, False, r))
    print(perf_test_delete(9_000, False, r))
    print(perf_test_delete(15_000, False, r))
    print(perf_test_delete(30_000, False, r))
    print(perf_test_delete(50_000, False, r))

    print("===Delete Balanced===")
    print(perf_test_delete(10, True, r))
    print(perf_test_delete(300, True, r))
    print(perf_test_delete(100, True, r))
    print(perf_test_delete(500, True, r))
    print(perf_test_delete(1_000, True, r))
    print(perf_test_delete(3_000, True, r))
    print(perf_test_delete(9_000, True, r))
    print(perf_test_delete(15_000, True, r))
    print(perf_test_delete(30_000, True, r))
    print(perf_test_delete(50_000, True, r))

    print("===Union===")
    print(perf_test_union(10, False))
    print(perf_test_union(100, False))
    print(perf_test_union(300, False))
    print(perf_test_union(500, False))
    print(perf_test_union(1_000, False))
    print(perf_test_union(3_000, False))
    print(perf_test_union(9_000, False))
    print(perf_test_union(15_000, False))
    print(perf_test_union(30_000, False))
    print(perf_test_union(50_000, False))

    print("===Delete Balanced===")
    print(perf_test_union(10, True))
    print(perf_test_union(300, True))
    print(perf_test_union(100, True))
    print(perf_test_union(500, True))
    print(perf_test_union(1_000, True))
    print(perf_test_union(3_000, True))
    print(perf_test_union(9_000, True))
    print(perf_test_union(15_000, True))
    print(perf_test_union(30_000, True))
    print(perf_test_union(50_000, True))

    print("===Intersection===")
    print(perf_test_intersection(10, False))
    print(perf_test_intersection(100, False))
    print(perf_test_intersection(300, False))
    print(perf_test_intersection(500, False))
    print(perf_test_intersection(1_000, False))
    print(perf_test_intersection(3_000, False))
    print(perf_test_intersection(9_000, False))
    print(perf_test_intersection(15_000, False))
    print(perf_test_intersection(30_000, False))
    print(perf_test_intersection(50_000, False))

    print("===Intersection Balanced===")
    print(perf_test_intersection(10, True))
    print(perf_test_intersection(300, True))
    print(perf_test_intersection(100, True))
    print(perf_test_intersection(500, True))
    print(perf_test_intersection(1_000, True))
    print(perf_test_intersection(3_000, True))
    print(perf_test_intersection(9_000, True))
    print(perf_test_intersection(15_000, True))
    print(perf_test_intersection(30_000, True))
    print(perf_test_intersection(50_000, True))

    print("===Difference===")
    print(perf_test_difference(10, False))
    print(perf_test_difference(100, False))
    print(perf_test_difference(300, False))
    print(perf_test_difference(500, False))
    print(perf_test_difference(1_000, False))
    print(perf_test_difference(3_000, False))
    print(perf_test_difference(9_000, False))
    print(perf_test_difference(15_000, False))
    print(perf_test_difference(30_000, False))
    print(perf_test_difference(50_000, False))

    print("===Difference Balanced===")
    print(perf_test_difference(10, True))
    print(perf_test_difference(300, True))
    print(perf_test_difference(100, True))
    print(perf_test_difference(500, True))
    print(perf_test_difference(1_000, True))
    print(perf_test_difference(3_000, True))
    print(perf_test_difference(9_000, True))
    print(perf_test_difference(15_000, True))
    print(perf_test_difference(30_000, True))
    print(perf_test_difference(50_000, True))

    print("===Symmetric Difference===")
    print(perf_test_symmetric_difference(10, False))
    print(perf_test_symmetric_difference(100, False))
    print(perf_test_symmetric_difference(300, False))
    print(perf_test_symmetric_difference(500, False))
    print(perf_test_symmetric_difference(1_000, False))
    print(perf_test_symmetric_difference(3_000, False))
    print(perf_test_symmetric_difference(9_000, False))
    print(perf_test_symmetric_difference(15_000, False))
    print(perf_test_symmetric_difference(30_000, False))
    print(perf_test_symmetric_difference(50_000, False))

    print("===Symmetric Difference Balanced===")
    print(perf_test_symmetric_difference(10, True))
    print(perf_test_symmetric_difference(300, True))
    print(perf_test_symmetric_difference(100, True))
    print(perf_test_symmetric_difference(500, True))
    print(perf_test_symmetric_difference(1_000, True))
    print(perf_test_symmetric_difference(3_000, True))
    print(perf_test_symmetric_difference(9_000, True))
    print(perf_test_symmetric_difference(15_000, True))
    print(perf_test_symmetric_difference(30_000, True))
    print(perf_test_symmetric_difference(50_000, True))
