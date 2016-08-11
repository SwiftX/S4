public protocol AsyncResponseSerializer {
    init(stream: AsyncStream)
    func serialize(_ response: Response, completion: @escaping ((Void) throws -> Void) -> Void)
}
