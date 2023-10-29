from math import min

fn int_to_str(i: Int) -> String:
    return String(i)

fn int_eq(i1: Int, i2: Int) -> Bool:
    return i1 == i2

fn cmp_strl(a: StringLiteral, b: StringLiteral) -> Int:
    let l = min(len(a), len(b))
    let p1 = DTypePointer[DType.int8](a.data()).bitcast[DType.uint8]()
    let p2 = DTypePointer[DType.int8](b.data()).bitcast[DType.uint8]()
    let diff = memcmp(p1, p2, l)

    return diff if diff != 0 else len(a) - len(b)

fn stsl(a: StringLiteral) -> String:
    return a