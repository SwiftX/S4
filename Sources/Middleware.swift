public protocol Middleware {
    func respond(request: Request, chainingTo next: Responder) throws -> Response
}

extension Middleware {
    public func chain(responder: Responder) -> Responder {
        return BasicResponder { request in
            return try self.respond(request, chainingTo: responder)
        }
    }
}

#if swift(>=3.0)
extension Collection where Self.Iterator.Element == Middleware {
    public func chain(responder: Responder) -> Responder {
        var responder = responder

        for middleware in self.reversed() {
            responder = middleware.chain(responder)
        }

        return responder
    }
}
#else
extension CollectionType where Self.Generator.Element == Middleware {
    public func chain(responder: Responder) -> Responder {
        var responder = responder

        for middleware in self.reverse() {
            responder = middleware.chain(responder)
        }

        return responder
    }
}
#endif
