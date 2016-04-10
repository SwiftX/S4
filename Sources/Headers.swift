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

extension Headers: Sequence {
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

    public subscript(field: CaseInsensitiveString) -> Header {
        get {
            return headers[field] ?? []
        }

        set(header) {
            headers[field] = header
        }
    }

    public subscript(field: CaseInsensitiveStringRepresentable) -> Header {
        get {
            return headers[field.caseInsensitiveString] ?? []
        }

        set(header) {
            headers[field.caseInsensitiveString] = header
        }
    }
}
