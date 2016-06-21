public protocol AsyncResponseSerializer {
    init(stream: AsyncStream)
    func serialize(_ response: Response, completion: ((Void) throws -> Void) -> Void)
}
