public protocol ResponseSerializer {
    func serialize(response: Response, to stream: Stream) throws
}
