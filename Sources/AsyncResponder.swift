public protocol AsyncResponder {
    func respond(to request: Request, result: (Void throws -> Response) -> Void)
}

public typealias AsyncRespond = (to: Request, result: (Void throws -> Response) -> Void) -> Void

public struct BasicAsyncResponder: AsyncResponder {
    let respond: AsyncRespond

    public init(_ respond: AsyncRespond) {
        self.respond = respond
    }

    public func respond(to request: Request, result: (Void throws -> Response) -> Void) {
        return self.respond(to: request, result: result)
    }
}
