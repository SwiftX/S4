public protocol Responder: AsyncResponder {
    func respond(to request: Request) throws -> Response
}

extension Responder {
    public func respond(to request: Request, result: ((Void) throws -> Response) -> Void) {
        result { try self.respond(to: request) }
    }
}

public typealias Respond = (to: Request) throws -> Response

public struct BasicResponder: Responder {
    let respond: Respond

    public init(_ respond: Respond) {
        self.respond = respond
    }

    public func respond(to request: Request) throws -> Response {
        return try self.respond(to: request)
    }
}
