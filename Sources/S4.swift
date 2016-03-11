public typealias Byte = UInt8

public struct Data {
    public var bytes: [Byte]
}

public protocol Stream {
    var closed: Bool { get }
    func close() -> Bool
    func receive() throws -> Data
    func send(data: Data) throws
    func flush() throws
}

public protocol StreamClient {
    func connect() throws -> Stream
}

public protocol StreamServer {
    func accept() throws -> Stream
}

public typealias HTTPVersion = (major: Int, minor: Int)

public struct HTTPHeader {
    public let name: String
    public let value: String
}

public typealias HTTPHeaders = [HTTPHeader]

public enum HTTPBody {
    case BufferBody(Data)
    case StreamBody(Stream)
}

public typealias Storage = [String: Any]

public protocol HTTPMessage {
    var version: HTTPVersion { get set }
    var headers: HTTPHeaders { get set }
    var body: HTTPBody { get set }
    var storage: Storage { get set }
}

public enum HTTPMethod {
    case Delete
    case Get
    case Head
    case Post
    case Put
    case Connect
    case Options
    case Trace
    case Copy
    case Lock
    case MkCol
    case Move
    case PropFind
    case PropPatch
    case Search
    case Unlock
    case Bind
    case Rebind
    case Unbind
    case ACL
    case Report
    case MkActicity
    case Checkout
    case Merge
    case MSearch
    case Notify
    case Subscribe
    case Unsubscribe
    case Patch
    case Purge
    case MkCalendar
    case Link
    case Unlink
    case Raw(method: String)
}

extension HTTPMethod: Hashable {
    public var hashValue: Int {
        switch self {
        case .Delete:      return 0
        case .Get:         return 1
        case .Head:        return 2
        case .Post:        return 3
        case .Put:         return 4
        case .Connect:     return 5
        case .Options:     return 6
        case .Trace:       return 7
        case .Copy:        return 8
        case .Lock:        return 9
        case .MkCol:       return 10
        case .Move:        return 11
        case .PropFind:    return 12
        case .PropPatch:   return 13
        case .Search:      return 14
        case .Unlock:      return 15
        case .Bind:        return 16
        case .Rebind:      return 17
        case .Unbind:      return 18
        case .ACL:         return 19
        case .Report:      return 20
        case .MkActicity:  return 21
        case .Checkout:    return 22
        case .Merge:       return 23
        case .MSearch:     return 24
        case .Notify:      return 25
        case .Subscribe:   return 26
        case .Unsubscribe: return 27
        case .Patch:       return 28
        case .Purge:       return 29
        case .MkCalendar:  return 30
        case .Link:        return 31
        case .Unlink:      return 32
        case .Raw(let method): return 33 + method.hashValue
        }
    }
}

public func ==(lhs: HTTPMethod, rhs: HTTPMethod) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

extension HTTPMethod: CustomStringConvertible {
    public var description: String {
        switch self {
        case .Delete:      return "DELETE"
        case .Get:         return "GET"
        case .Head:        return "HEAD"
        case .Post:        return "POST"
        case .Put:         return "PUT"
        case .Connect:     return "CONNECT"
        case .Options:     return "OPTIONS"
        case .Trace:       return "TRACE"
        case .Copy:        return "COPY"
        case .Lock:        return "LOCK"
        case .MkCol:       return "MKCOL"
        case .Move:        return "MOVE"
        case .PropFind:    return "PROPFIND"
        case .PropPatch:   return "PROPPATCH"
        case .Search:      return "SEARCH"
        case .Unlock:      return "UNLOCK"
        case .Bind:        return "BIND"
        case .Rebind:      return "REBIND"
        case .Unbind:      return "UNBIND"
        case .ACL:         return "ACL"
        case .Report:      return "REPORT"
        case .MkActicity:  return "MKACTIVITY"
        case .Checkout:    return "CHECKOUT"
        case .Merge:       return "MERGE"
        case .MSearch:     return "MSEARCH"
        case .Notify:      return "NOTIFY"
        case .Subscribe:   return "SUBSCRIBE"
        case .Unsubscribe: return "UNSUBSCRIBE"
        case .Patch:       return "PATCH"
        case .Purge:       return "PURGE"
        case .MkCalendar:  return "MKCALENDAR"
        case .Link:        return "LINK"
        case .Unlink:      return "UNLINK"
        default:           return "UNKNOWN"
        }
    }
}

public struct URI {
    public struct UserInfo {
        public var username: String
        public var password: String
    }

    public var scheme: String?
    public var userInfo: UserInfo?
    public var host: String?
    public var port: Int?
    public var path: String?
    public var query: [String: String]
    public var fragment: String?
}

public struct HTTPRequest: HTTPMessage {
    public var method: HTTPMethod
    public var uri: URI
    public var version: HTTPVersion
    public var headers: HTTPHeaders
    public var body: HTTPBody
    public var storage: Storage = [:]
}

public protocol HTTPRequestParser {
    func parse(data: Data) throws -> HTTPRequest?
}

public protocol HTTPRequestSerializer {
    func serialize(request: HTTPRequest, @noescape send: Data throws -> Void) throws
}

public enum HTTPStatus {
    case Continue
    case SwitchingProtocols
    case Processing

    case OK
    case Created
    case Accepted
    case NonAuthoritativeInformation
    case NoContent
    case ResetContent
    case PartialContent

    case MultipleChoices
    case MovedPermanently
    case Found
    case SeeOther
    case NotModified
    case UseProxy
    case SwitchProxy
    case TemporaryRedirect
    case PermanentRedirect

    case BadRequest
    case Unauthorized
    case PaymentRequired
    case Forbidden
    case NotFound
    case MethodNotAllowed
    case NotAcceptable
    case ProxyAuthenticationRequired
    case RequestTimeout
    case Conflict
    case Gone
    case LengthRequired
    case PreconditionFailed
    case RequestEntityTooLarge
    case RequestURITooLong
    case UnsupportedMediaType
    case RequestedRangeNotSatisfiable
    case ExpectationFailed
    case ImATeapot
    case AuthenticationTimeout
    case EnhanceYourCalm
    case UnprocessableEntity
    case Locked
    case FailedDependency
    case PreconditionRequired
    case TooManyRequests
    case RequestHeaderFieldsTooLarge

    case InternalServerError
    case NotImplemented
    case BadGateway
    case ServiceUnavailable
    case GatewayTimeout
    case HTTPVersionNotSupported
    case VariantAlsoNegotiates
    case InsufficientStorage
    case LoopDetected
    case NotExtended
    case NetworkAuthenticationRequired

    case Raw(statusCode: Int, reasonPhrase: String)
}

public struct HTTPResponse: HTTPMessage {
    public var version: HTTPVersion
    public var status: HTTPStatus
    public var headers: HTTPHeaders
    public var body: HTTPBody
    public var storage: Storage = [:]
}

public protocol HTTPResponseParser {
    func parse(data: Data) throws -> HTTPResponse?
}

public protocol HTTPResponseSerializer {
    func serialize(response: HTTPResponse, @noescape send: Data throws -> Void) throws
}

public protocol HTTPResponder {
    func respond(request: HTTPRequest) throws -> HTTPResponse
}

public protocol HTTPMiddleware {
    func respond(request: HTTPRequest, chain: HTTPResponder) throws -> HTTPResponse
}

public protocol HTTPClient: HTTPResponder {
    var client: StreamClient { get }
    var serializer: HTTPRequestSerializer { get }
    var parser: HTTPResponseParser { get }
}

public protocol HTTPServer {
    var server: StreamServer { get }
    var parser: HTTPRequestParser { get }
    var responder: HTTPResponder { get }
    var serializer: HTTPResponseSerializer  { get }
}

public protocol HTTPRoute: HTTPResponder {
    var path: String { get }
    var actions: [HTTPMethod: HTTPResponder] { get }
    var fallback: HTTPResponder { get }
}

public protocol HTTPRouter: HTTPResponder {
    var routes: [HTTPRoute] { get }
    var fallback: HTTPResponder { get }
    func match(request: HTTPRequest) -> HTTPRoute?
}