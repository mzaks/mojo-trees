from time import now
from trie_dict import TrieDict

fn vec[T: AnyType](*elements: T) -> DynamicVector[T]:
    let elements_list: VariadicList[T] = elements
    var result = DynamicVector[T](len(elements_list))
    for i in range(len(elements_list)):
        result.push_back(elements[i])
    return result

fn main():
    let corpus = vec('Lorem', 'ipsum', 'dolor', 'sit', 'amet,', 'consectetur', 'adipiscing', 'elit.', 'Quisque', 'orci', 'urna,', 'pretium', 'et', 'porta', 'ac,', 'porttitor', 'sit', 'amet', 'sem.', 'Fusce', 'sagittis', 'lorem', 'neque,', 'vitae', 'sollicitudin', 'elit', 'suscipit', 'et.', 'In', 'interdum', 'convallis', 'nisl', 'in', 'ornare.', 'Vestibulum', 'ante', 'ipsum', 'primis', 'in', 'faucibus', 'orci', 'luctus', 'et', 'ultrices', 'posuere', 'cubilia', 'curae;', 'Aliquam', 'erat', 'volutpat.', 'Morbi', 'mollis', 'iaculis', 'lectus', 'ac', 'tincidunt.', 'Fusce', 'nisi', 'lacus,', 'semper', 'eu', 'dignissim', 'et,', 'malesuada', 'non', 'mi.', 'Sed', 'euismod', 'urna', 'vel', 'elit', 'faucibus,', 'eu', 'bibendum', 'ante', 'fringilla.', 'Curabitur', 'tempus', 'in', 'turpis', 'at', 'mattis.', 'Aliquam', 'erat', 'volutpat.', 'Donec', 'maximus', 'elementum', 'felis,', 'sit', 'amet', 'dignissim', 'augue', 'tincidunt', 'blandit.', 'Aliquam', 'fermentum,', 'est', 'eu', 'mollis.')

    var t = TrieDict[Int]()
    var tik = now()
    var tok = now()
    var total = 0
    for i in range(len(corpus)):
        tik = now()
        t.put(corpus[i], i)
        tok = now()
        total += tok - tik
    
    print("Add 100 elements in", total / len(corpus), "ns on avg per entry")

    for i in range(len(corpus)):
        tik = now()
        let r = t.__contains__(corpus[i])
        tok = now()
        total += tok - tik

    print("Lookup 100 elements in", total / len(corpus), "ns on avg per entry")

    for i in range(len(corpus)):
        tik = now()
        let r = t.delete(corpus[i])
        tok = now()
        total += tok - tik

    print("Delete 100 elements in", total / len(corpus), "ns on avg per entry")
    print("Dict len:", t.__len__())
    