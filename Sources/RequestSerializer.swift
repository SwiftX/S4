public protocol RequestSerializer {
    func serialize(request: Request, to stream: Stream) throws
}
