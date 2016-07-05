public protocol AsyncRequestSerializer {
    init(stream: AsyncStream)
    func serialize(_ request: Request, completion: ((Void) throws -> Void) -> Void)
}
