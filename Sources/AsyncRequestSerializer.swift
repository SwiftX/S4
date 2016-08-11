public protocol AsyncRequestSerializer {
    init(stream: AsyncStream)
    func serialize(_ request: Request, completion: @escaping ((Void) throws -> Void) -> Void)
}
