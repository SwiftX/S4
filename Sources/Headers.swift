public struct Headers {
    public var headers: [CaseInsensitiveString: String]

    public init(_ headers: [CaseInsensitiveString: String]) {
        self.headers = headers
    }
}

extension Headers: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (CaseInsensitiveString, String)...) {
        var headers: [CaseInsensitiveString: String] = [:]

        for (key, value) in elements {
            headers[key] = value
        }

        self.headers = headers
    }
}

extension Headers: Sequence {
    #if swift(>=3.0)
    public func makeIterator() -> DictionaryIterator<CaseInsensitiveString, String> {
        return headers.makeIterator()
    }
    #else
    public func generate() -> DictionaryGenerator<CaseInsensitiveString, String> {
        return headers.generate()
    }
    #endif

    public var count: Int {
        return headers.count
    }

    public var isEmpty: Bool {
        return headers.isEmpty
    }

    public subscript(field: CaseInsensitiveString) -> String? {
        get {
            return headers[field]
        }

        set(header) {
            headers[field] = header
        }
    }

    public subscript(field: CaseInsensitiveStringRepresentable) -> String? {
        get {
            return headers[field.caseInsensitiveString]
        }

        set(header) {
            headers[field.caseInsensitiveString] = header
        }
    }
}
