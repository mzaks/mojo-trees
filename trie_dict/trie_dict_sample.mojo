from trie_dict import TrieDict

fn main():
    var t = TrieDict[Int]()
    _ = t.put("Maxim", 12)
    t.debug()
    _ = t.put("Max", 11)
    t.debug()
    _ = t.put("Marina", 13)
    t.debug()
    _ = t.put("Marinala", 14)
    t.debug()
    _ = t.put("Leo", 15)
    t.debug()
    _ = t.put("Daria", 16)
    t.debug()
    _ = t.put("Dario", 17)
    t.debug()
    _ = t.put("Dominique", 18)
    t.debug()

    print("Marina", t.__contains__("Marina"))
    print("Mari", t.__contains__("Mari"))
    print("Dominique", t.__contains__("Dominique"))

    print("Dominique", t.get("Dominique", 0))
    print("Dom", t.get("Dom", 0))
    print("Daria", t.get("Daria", 0))

    _ = t.put("Daria", 26)
    print("Daria", t.get("Daria", 0))
