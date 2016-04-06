public protocol AsyncMiddleware {
    func respond(request: Request, chainingTo next: AsyncResponder, result: (Void throws -> Response) -> Void)
}

extension AsyncMiddleware {
    public func chain(responder: AsyncResponder) -> AsyncResponder {
        return BasicAsyncResponder { request, result in
            self.respond(request, chainingTo: responder, result: result)
        }
    }
}

#if swift(>=3.0)
extension Collection where Self.Iterator.Element == AsyncMiddleware {
    public func chain(responder: AsyncResponder) -> AsyncResponder {
        var responder = responder

        for middleware in self.reversed() {
            responder = middleware.chain(responder)
        }

        return responder
    }
}
#else
extension CollectionType where Self.Generator.Element == AsyncMiddleware {
    public func chain(responder: AsyncResponder) -> AsyncResponder {
        var responder = responder

        for middleware in self.reverse() {
            responder = middleware.chain(responder)
        }

        return responder
    }
}
#endif
