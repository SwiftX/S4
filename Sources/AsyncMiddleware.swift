public protocol AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder, result: ((Void) throws -> Response) -> Void)
}

extension AsyncMiddleware {
    public func chain(to responder: AsyncResponder) -> AsyncResponder {
        return BasicAsyncResponder { request, result in
            self.respond(to: request, chainingTo: responder, result: result)
        }
    }
}

#if swift(>=3.0)
extension Collection where Self.Iterator.Element == AsyncMiddleware {
    public func chain(to responder: AsyncResponder) -> AsyncResponder {
        var responder = responder

        for middleware in self.reversed() {
            responder = middleware.chain(to: responder)
        }

        return responder
    }
}
#else
extension CollectionType where Self.Generator.Element == AsyncMiddleware {
    public func chain(to responder: AsyncResponder) -> AsyncResponder {
        var responder = responder

        for middleware in self.reverse() {
            responder = middleware.chain(to: responder)
        }

        return responder
    }
}
#endif
