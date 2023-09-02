from fiby_tree import FibyTree
from time import now
from math import min

fn cmp_strl(a: StringLiteral, b: StringLiteral) -> Int:
    let l = min(len(a), len(b))
    let p1 = DTypePointer[DType.int8](a.data()).bitcast[DType.uint8]()
    let p2 = DTypePointer[DType.int8](b.data()).bitcast[DType.uint8]()
    let diff = memcmp(p1, p2, l)

    return diff if diff != 0 else len(a) - len(b)

fn stsl(a: StringLiteral) -> String:
    return a

fn main():
    var tik = now()
    var ft = FibyTree[StringLiteral, cmp_strl, stsl]('Lorem', 'ipsum', 'dolor', 'sit', 'amet,', 'consectetur', 'adipiscing', 'elit.', 'Quisque', 'orci', 'urna,', 'pretium', 'et', 'porta', 'ac,', 'porttitor', 'sit', 'amet', 'sem.', 'Fusce', 'sagittis', 'lorem', 'neque,', 'vitae', 'sollicitudin', 'elit', 'suscipit', 'et.', 'In', 'interdum', 'convallis', 'nisl', 'in', 'ornare.', 'Vestibulum', 'ante', 'ipsum', 'primis', 'in', 'faucibus', 'orci', 'luctus', 'et', 'ultrices', 'posuere', 'cubilia', 'curae;', 'Aliquam', 'erat', 'volutpat.', 'Morbi', 'mollis', 'iaculis', 'lectus', 'ac', 'tincidunt.', 'Fusce', 'nisi', 'lacus,', 'semper', 'eu', 'dignissim', 'et,', 'malesuada', 'non', 'mi.', 'Sed', 'euismod', 'urna', 'vel', 'elit', 'faucibus,', 'eu', 'bibendum', 'ante', 'fringilla.', 'Curabitur', 'tempus', 'in', 'turpis', 'at', 'mattis.', 'Aliquam', 'erat', 'volutpat.', 'Donec', 'maximus', 'elementum', 'felis,', 'sit', 'amet', 'dignissim', 'augue', 'tincidunt', 'blandit.', 'Aliquam', 'fermentum,', 'est', 'eu', 'mollis.')
    var tok = now()
    var duration = tok - tik
    print("Create 100 entry set in", duration, "ns")
    print("Set len:", ft.__len__())

    tik = now()
    ft.balance()
    tok = now()
    duration = tok - tik
    print("Balanced the set in:", duration, "ns")

    tik = now()
    let elements = ft.sorted_elements()
    tok = now()
    duration = tok - tik
    print("Get sorted elements in:", duration, "ns")
    
    var total = 0
    for i in range(len(elements)):
        tik = now()
        let r = ft.__contains__(elements[i])
        tok = now()
        total += tok - tik
    
    print("Check contains in:", total / len(elements), "ns on avg per element")

    total = 0
    for i in range(len(elements)):
        tik = now()
        let r = ft.delete(elements[i])
        tok = now()
        total += tok - tik
    
    print("Delete all in:", total / len(elements), "ns on avg per element")
