public protocol Client: Responder {
    init(connectingTo uri: URI) throws
}
