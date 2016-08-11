/**
    Represents the body of the HTTP message.

    An HTTP message body contains the bytes of data that
    are transmitted immediately following the headers.

    - buffer:        Simplest type of HTTP message body.
                     Represents a `Data` object containing
                     a byte array.

    - receiver:      Contains a `ReceivingStream` that can be drained
                     in chunks to access the body's data.

    - sender:        Contains a closure that accepts a `SendingStream`
                     object to which the body's data should be sent.
 
    - asyncReceiver: Contains a `AsyncReceivingStream` that can be drained
                     in chunks to access the body's data.
 
    - asyncSender:   Contains a closure that accepts a `AsyncSendingStream`
                     object to which the body's data should be sent.
 
*/
public enum Body {
    case buffer(Data)
    case receiver(ReceivingStream)
    case sender((SendingStream) throws -> Void)
    case asyncReceiver(AsyncReceivingStream)
    case asyncSender((AsyncSendingStream, @escaping ((Void) throws -> Void) -> Void) -> Void)
}

public enum BodyError: Error {
    case inconvertibleType
}

extension Body {
    ///Returns true if body is case `buffer`
    public var isBuffer: Bool {
        switch self {
        case .buffer: return true
        default: return false
        }
    }

    ///Returns true if body is case `receiver`
    public var isReceiver: Bool {
        switch self {
        case .receiver: return true
        default: return false
        }
    }

    ///Returns true if body is case `sender`
    public var isSender: Bool {
        switch self {
        case .sender: return true
        default: return false
        }
    }

    ///Returns true if body is case `asyncReceiver`
    public var isAsyncReceiver: Bool {
        switch self {
        case .asyncReceiver: return true
        default: return false
        }
    }
    
    ///Returns true if body is case `asyncSender`
    public var isAsyncSender: Bool {
        switch self {
        case .asyncSender: return true
        default: return false
        }
    }
}
