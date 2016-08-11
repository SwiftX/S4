public protocol AsyncResponder {
    func respond(to request: Request, result: @escaping ((Void) throws -> Response) -> Void)
}

public typealias AsyncRespond = (_ to: Request, _ result: @escaping ((Void) throws -> Response) -> Void) -> Void

public struct BasicAsyncResponder: AsyncResponder {
    let respond: AsyncRespond

    public init(_ respond: AsyncRespond) {
        self.respond = respond
    }

    public func respond(to request: Request, result: @escaping ((Void) throws -> Response) -> Void) {
        return self.respond(to: request, result: result)
    }
}
