struct TrieDict[Value: AnyType]:
    var chars: DynamicVector[Int8]
    var next: DynamicVector[UInt16]
    var sibling: DynamicVector[UInt16]
    var value_index: DynamicVector[UInt8]
    var values: DynamicVector[Value]
    var deleted: UInt8

    fn __init__(inout self):
        self.chars = DynamicVector[Int8]()
        self.next = DynamicVector[UInt16]()
        self.sibling = DynamicVector[UInt16]()
        self.value_index = DynamicVector[UInt8]()
        self.values = DynamicVector[Value]()
        self.deleted = 0

    fn __len__(self) -> Int:
        return len(self.values) - self.deleted.to_int()

    fn __contains__(self, key: String) -> Bool:
        let chars = key._buffer
        let key_char_offset = self._find_prefix_count(chars)
        let key_offset = key_char_offset.get[0, Int]()
        let char_index = key_char_offset.get[1, Int]()
        if key_offset == len(chars):
            return self.value_index[char_index] > 0
        return False

    fn get(self, key: String, default: Value) -> Value:
        let chars = key._buffer
        let key_char_offset = self._find_prefix_count(chars)
        let key_offset = key_char_offset.get[0, Int]()
        let char_index = key_char_offset.get[1, Int]()
        if key_offset == len(chars):
            if self.value_index[char_index] > 0:
                return self.values[(self.value_index[char_index] - 1).to_int()]
        return default

    fn delete(inout self, key: String):
        let chars = key._buffer
        let key_char_offset = self._find_prefix_count(chars)
        let key_offset = key_char_offset.get[0, Int]()
        let char_index = key_char_offset.get[1, Int]()
        if key_offset == len(chars):
            if self.value_index[char_index] > 0:
                self.value_index[char_index] = 0
                self.deleted += 1    


    fn put(inout self, key: String, value: Value):
        let chars = key._buffer
        let key_char_offset = self._find_prefix_count(chars)
        let key_offset = key_char_offset.get[0, Int]()
        let char_index = key_char_offset.get[1, Int]()
        if key_offset == len(chars):
            if self.value_index[char_index] == 0:
                self.values.push_back(value)
                self.value_index[char_index] = UInt8(len(self.values))
                return
            # replace
            self.values[(self.value_index[char_index] - 1).to_int()] = value
            return
        if len(self.chars) > char_index:
            if char_index == len(self.chars) - 1:
                self.next[char_index] = UInt16(len(self.chars))
            else:
                self.sibling[char_index] = UInt16(len(self.chars))
        for i in range(key_offset, len(chars)):
            self.chars.push_back(chars[i])
            let self_index = UInt16(len(self.sibling))
            self.sibling.push_back(self_index)
            self.next.push_back(self_index + 1)
            self.value_index.push_back(0)
        self.next[len(self.next) - 1] -= 1 
        self.values.push_back(value)
        self.value_index[len(self.next) - 1] = UInt8(len(self.values))

    fn _find_prefix_count(self, key: DynamicVector[Int8]) -> (Int, Int):
        if len(self.chars) == 0:
            return 0, 0
        var char_index = 0
        for key_index in range(len(key)):
            while True:
                if self.chars[char_index] != key[key_index]:
                    if self._has_sibling(char_index):
                        char_index = self.sibling[char_index].to_int()
                    else:
                        return key_index, char_index
                else:
                    if self._has_next(char_index):
                        char_index = self.next[char_index].to_int()
                        break
                    else:
                        return key_index + 1, char_index
        return len(key), char_index - 1

    fn _has_sibling(self, char_index: Int) -> Bool:
        return self.sibling[char_index].to_int() != char_index

    fn _has_next(self, char_index: Int) -> Bool:
        return self.next[char_index].to_int() != char_index

    fn debug(self):
        print("Num nodes:", len(self.next))
        print("Num values:", len(self.values))
        var s1: String = "Chars: ["
        for i in range(len(self.chars)):
            s1 += String(self.chars[i].to_int())
            s1 += ","
        s1 += "]"
        print(s1)
        s1 = "Next: ["
        for i in range(len(self.next)):
            s1 += String(self.next[i])
            s1 += ","
        s1 += "]"
        print(s1)
        s1 = "Sibling: ["
        for i in range(len(self.sibling)):
            s1 += String(self.sibling[i])
            s1 += ","
        s1 += "]"
        print(s1)
        s1 = "Value index: ["
        for i in range(len(self.value_index)):
            s1 += String(self.value_index[i])
            s1 += ","
        s1 += "]"
        print(s1)
