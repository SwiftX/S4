public struct Headers {
    public var headers: [CaseInsensitiveString: Header]

    public init(_ headers: [CaseInsensitiveString: Header]) {
        self.headers = headers
    }
}

extension Headers: DictionaryLiteralConvertible {
    public init(dictionaryLiteral elements: (CaseInsensitiveString, Header)...) {
        var headers: [CaseInsensitiveString: Header] = [:]

        for (key, value) in elements {
            headers[key] = value
        }

        self.headers = headers
    }
}

#if swift(>=3.0)
extension Headers: Sequence {}
#else
extension Headers: SequenceType {}
#endif

extension Headers {
    #if swift(>=3.0)
    public func makeIterator() -> DictionaryIterator<CaseInsensitiveString, Header> {
        return headers.makeIterator()
    }
    #else
    public func generate() -> DictionaryGenerator<CaseInsensitiveString, Header> {
        return headers.generate()
    }
    #endif

    public var count: Int {
        return headers.count
    }

    public var isEmpty: Bool {
        return headers.isEmpty
    }

    public subscript(name: CaseInsensitiveString) -> Header {
        get {
            return headers[name] ?? []
        }

        set(headerValues) {
            headers[name] = headerValues
        }
    }
}
