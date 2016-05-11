/**
    Represents the body of the HTTP message.

    An HTTP message body contains the bytes of data that
    are transmitted immediately following the headers.

    - buffer:   Simplest type of HTTP message body.
                Represents a `Data` object containing
                a byte array.

    - receiver: Contains a `Stream` that can be drained
                in chunks to access the body's data.

    - sender:   Contains a closure that accepts a `Stream`
                object to which the body's data should be sent.

*/
public enum Body {
    case buffer(Data)
    case receiver(Stream)
    case sender((Stream) throws -> Void)
}

extension Body {
    /**
        Converts the body's contents into a `Data` buffer.

        If the body is a receiver or sender type,
        it will be drained.
    */
    public mutating func becomeBuffer(timingOut deadline: Double = .never) throws -> Data {
        switch self {
        case .buffer(let data):
            return data
        case .receiver(let receiver):
            let data = Drain(for: receiver, timingOut: deadline).data
            self = .buffer(data)
            return data
        case .sender(let sender):
            let drain = Drain()
            try sender(drain)
            let data = drain.data

            self = .buffer(data)
            return data
        }
    }

    ///Returns true if body is case `buffer`
    public var isBuffer: Bool {
        switch self {
        case .buffer: return true
        default: return false
        }
    }

    /**
        Converts the body's contents into a `Stream`
        that can be received in chunks.
    */
    public mutating func becomeReceiver() throws -> Stream {
        switch self {
        case .receiver(let stream):
            return stream
        case .buffer(let data):
            let stream = Drain(for: data)
            self = .receiver(stream)
            return stream
        case .sender(let sender):
            let stream = Drain()
            try sender(stream)
            self = .receiver(stream)
            return stream
        }
    }

    ///Returns true if body is case `receiver`
    public var isReceiver: Bool {
        switch self {
        case .receiver: return true
        default: return false
        }
    }

    /**
        Converts the body's contents into a closure
        that accepts a `Stream`.
    */
    public mutating func becomeSender(timingOut deadline: Double = .never) -> ((Stream) throws -> Void) {
        switch self {
        case .buffer(let data):
            let closure: ((Stream) throws -> Void) = { sender in
                try sender.send(data, timingOut: deadline)
            }
            self = .sender(closure)
            return closure
        case .receiver(let receiver):
            let closure: ((Stream) throws -> Void) = { sender in
                let data = Drain(for: receiver, timingOut: deadline).data
                try sender.send(data, timingOut: deadline)
            }
            self = .sender(closure)
            return closure
        case .sender(let sender):
            return sender
        }
    }

    ///Returns true if body is case `sender`
    public var isSender: Bool {
        switch self {
        case .sender: return true
        default: return false
        }
    }
}
