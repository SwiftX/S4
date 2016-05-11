public struct Response: Message {
    public var version: Version
    public var status: Status
    public var headers: Headers
    public var body: Body
    public var storage: [String: Any] = [:]

    public init(version: Version, status: Status, headers: Headers, body: Body) {
        self.version = version
        self.status = status
        self.headers = headers
        self.body = body
    }
}

public protocol ResponseInitializable {
    init(response: Response)
}

public protocol ResponseRepresentable {
    var response: Response { get }
}

public protocol ResponseConvertible: ResponseInitializable, ResponseRepresentable {}

extension Response {
    public init(status: Status = .ok, headers: Headers = [:], body: Data = []) {
        self.init(
            version: Version(major: 1, minor: 1),
            status: status,
            headers: headers,
            body: .buffer(body)
        )

        self.headers["Content-Length"] += body.count.description
    }

    public init(status: Status = .ok, headers: Headers = [:], body: Stream) {
        self.init(
            version: Version(major: 1, minor: 1),
            status: status,
            headers: headers,
            body: .receiver(body)
        )

        self.headers["Transfer-Encoding"] = "chunked"
    }

    public init(status: Status = .ok, headers: Headers = [:], body: (Stream) throws -> Void) {
        self.init(
            version: Version(major: 1, minor: 1),
            status: status,
            headers: headers,
            body: .sender(body)
        )

        self.headers["Transfer-Encoding"] = "chunked"
    }
}
