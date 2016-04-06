public protocol AsyncClient: AsyncResponder {
    init(connectingTo uri: URI) throws
}
