public struct Header {
    public var values: [String]

    public init(_ values: [String]) {
        self.values = values
    }
}

extension Header {
    public init(_ value: String) {
        self.init([value])
    }
}

#if swift(>=3.0)
extension Header: RangeReplaceableCollection {}
#else
extension Header: RangeReplaceableCollectionType {}
#endif

extension Header {
    public init() {
        self.init([])
    }

    #if swift(>=3.0)
    public init(repeating repeatedValue: String, count: Int) {
        self.init([String](repeating: repeatedValue, count: count))
    }
    #else
    public init(count: Int, repeatedValue: String) {
        self.init([String](count: count, repeatedValue: repeatedValue))
    }
    #endif

    #if swift(>=3.0)
    public mutating func replaceSubrange<C : Collection where C.Iterator.Element == String>(subRange: Range<Int>, with newElements: C) {
        self.values.replaceSubrange(subRange, with: newElements)
    }
    #else
    public mutating func replaceRange<C : CollectionType where C.Generator.Element == String>(subRange: Range<Int>, with newElements: C) {
        self.values.replaceRange(subRange, with: newElements)
    }
    #endif

    public mutating func reserveCapacity(n: Int) {
        self.values.reserveCapacity(n)
    }

    #if swift(>=3.0)
    public init<S : Sequence where S.Iterator.Element == String>(_ elements: S) {
    self.init([String](elements))
    }
    #else
    public init<S : SequenceType where S.Generator.Element == String>(_ elements: S) {
        self.init([String](elements))
    }
    #endif

    public mutating func append(x: String) {
        self.values.append(x)
    }

    #if swift(>=3.0)
    public mutating func append<S : Sequence where S.Iterator.Element == String>(contentsOf newElements: S) {
        self.values.append(contentsOf: newElements)
    }
    #else
    public mutating func appendContentsOf<S : SequenceType where S.Generator.Element == String>(newElements: S) {
        self.values.appendContentsOf(newElements)
    }
    #endif

    #if swift(>=3.0)
    public mutating func insert(newElement: String, at i: Int) {
        self.values.insert(newElement, at: i)
    }
    #else
    public mutating func insert(newElement: String, atIndex i: Int) {
        self.values.insert(newElement, atIndex: i)
    }
    #endif

    #if swift(>=3.0)
    public mutating func insert<S : Collection where S.Iterator.Element == String>(contentsOf newElements: S, at i: Int) {
        self.values.insert(contentsOf: newElements, at: i)
    }
    #else
    public mutating func insertContentsOf<S : CollectionType where S.Generator.Element == String>(newElements: S, at i: Int) {
        self.values.insertContentsOf(newElements, at: i)

    }
    #endif

    #if swift(>=3.0)
    public mutating func remove(at i: Int) -> String {
        return self.values.remove(at: i)
    }
    #else
    public mutating func removeAtIndex(i: Int) -> String {
        return self.values.removeAtIndex(i)
    }
    #endif

    public mutating func removeFirst() -> String {
        return self.values.removeFirst()
    }

    public mutating func removeFirst(n: Int) {
        self.values.removeFirst(n)
    }

    #if swift(>=3.0)
    public mutating func removeSubrange(bounds: Range<Int>) {
        self.values.removeSubrange(bounds)
    }
    #else
    public mutating func removeRange(bounds: Range<Int>) {
        self.values.removeRange(bounds)
    }
    #endif

    #if swift(>=3.0)
    public mutating func removeAll(keepingCapacity keepCapacity: Bool) {
        self.values.removeAll(keepingCapacity: keepCapacity)
    }
    #else
    public mutating func removeAll(keepCapacity keepCapacity: Bool) {
        self.values.removeAll(keepCapacity: keepCapacity)
    }
    #endif
}

#if swift(>=3.0)
extension Header: MutableCollection {}
#else
extension Header: MutableCollectionType {}
#endif

extension Header {
    #if swift(>=3.0)
    public func makeIterator() -> IndexingIterator<[String]> {
        return values.makeIterator()
    }
    #else
    public func generate() -> IndexingGenerator<[String]> {
        return values.generate()
    }
    #endif

    public var startIndex: Int {
        return values.startIndex
    }

    public var endIndex: Int {
        return values.endIndex
    }

    public var count: Int {
        return values.count
    }

    public subscript(index: Int) -> String {
        get {
            return values[index]
        }

        set(value) {
            values[index] = value
        }
    }

    public subscript (bounds: Range<Int>) -> ArraySlice<String> {
        get {
            return values[bounds]
        }

        set(slice) {
            values[bounds] = slice
        }
    }
}

extension Header: IntegerLiteralConvertible {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(String(value))
    }
}

extension Header: FloatLiteralConvertible {
    public init(floatLiteral value: FloatLiteralType) {
        self.init(String(value))
    }
}

extension Header: StringLiteralConvertible {
    public init(stringLiteral string: String) {
        self.init(string)
    }

    public init(extendedGraphemeClusterLiteral string: String){
        self.init(string)
    }

    public init(unicodeScalarLiteral string: String){
        self.init(string)
    }
}

extension Header: ArrayLiteralConvertible {
    public init(arrayLiteral elements: String...) {
        self.init(elements)
    }
}

extension Header: Equatable {}

public func ==(lhs: Header, rhs: Header) -> Bool {
    return lhs.values == rhs.values
}
