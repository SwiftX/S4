# S4 - Server Side Swift Standards

## Mission

It is Swift X's mission to create concise, clear, and well-documented standards to which all Swift projects can conform. By standarzing certain common functionalities, Swift X allows for radically improved cross-project compatibility for anything Swift. More compatibility means more collaboration which benefits each individual project as well as the Swift community as a whole.

Swift X strives to maintain the following core beliefs for all of its standards:
- Inclusive
    - Swift X standards should be unbiased and compatible with all Swift projects. 
- Community
    - Open Source and open to comments, criticisms, and pull requests. 
- Performant
    - Conforming to Swift X standards should have the minimum possible impact on performance possible.
- Minimum viable requirements
    - Only the code that is absolutely necessary for cross-project compatibility will be included. 
- Best practices
    - Swift X should abide by any widely accepted best practices in the Swift community, like naming conventions. 

## Byte

The `Byte` type represents a byte.

```swift
public typealias Byte = UInt8
```

### Motivation

`Byte` is clearer than `UInt8` in the context of binary data.

## Data

The `Data` type represents binary data as a collection of bytes.

> An alternative name could be `Buffer`.

```swift
public struct Data {
    public var bytes: [Byte]
}
```

### Motivation

Binary data types facilitate standardization of low level operations, especially when interfacing with C API.

```swift
let bytesWritten = data.withUnsafeBufferPointer {
    write(fd, $0.baseAddress, $0.count)
}
```

`Data` could be simply a typealias:

```swift
typealias Data = [Byte]
```

But that wouldn't allow it to conform to protocols. Wrapping `[Byte]` in a `struct` gives much more freedom. 

```swift
extension Data: CustomStringConvertible {
    public var description: String {
        return (try? String(data: self)) ?? hexDescription
    }
}
```

### Alternative

An alternative would be to store the binary data using raw pointes.

```swift
public struct Data {
    var bytes: UnsafeMutablePointer<Void>
    var length: Int
}
```

## Stream

The `Stream` protocol represents a bi-directional stream of binary data.

```swift
public protocol Stream {
    var closed: Bool { get }
    func close() -> Bool
    func receive() throws -> Data
    func send(data: Data) throws
    func flush() throws
}
```

### Motivation

With an abstraction for a stream we can avoid tight coupling and get the advantage of composition. One could, for example, wrap a raw `TCP` stream in an `SSL` stream that encrypts/decrypts the binary data coming from the raw stream.

```swift
public final class SSLStream: Stream {
    private let context: SSLContext
    private let rawStream: Stream

	public init(context: SSLContext, rawStream: Stream) throws {
		...
	}
}
```

The API consuming the stream doesn't need to know how the binary data is created. It only needs the binary data.

## StreamClient

The `StreamClient` protocol represents a client that can start a connection and return a stream of binary data representing that connection.

```swift
public protocol StreamClient {
    func connect() throws -> Stream
}
```

### Motivation

Having an abstraction for a client reduces tight coupling and allows the consumer API to focus solely on the binary data being transmitted through the stream.

## StreamServer

The `StreamServer` protocol represents a server that can accept a connection and return a stream of binary data representing that connection.

```swift
public protocol StreamServer {
    func accept() throws -> Stream
}
```

### Motivation

Having an abstraction for a server reduces tight coupling and allows the consumer API to focus solely on the binary data being transmitted through the stream.

## HTTPVersion

The `HTTPVersion` type represents an HTTP version.

```swift
public typealias HTTPVersion = (major: Int, minor: Int)
```

### Motivation

HTTP version is needed to handle protocol differences properly.

## HTTPHeader

The `HTTPHeader` type represents an HTTP header.

```swift
public struct HTTPHeader {
    let name: String
    let value: String
}
```

### Motivation

Having `HTTPHeader` as a `struct` allows it to conform to protocols.

## HTTPHeaders

The `HTTPHeaders` type represents HTTP headers.

```swift
public typealias HTTPHeaders = [HTTPHeader]
```

### Motivation

Unfortunately the HTTP protocol allows duplicate headers (see `Set-Cookie`). So we have to make it an array instead of a dictionary.

## HTTPBody

The `HTTPBody` type represents an HTTP body in buffer or stream form.

```swift
public enum HTTPBody {
    case BufferBody(Data)
    case StreamBody(Stream)
}
```

### Motivation

Buffer bodies are best suited for HTTP messages with `Content-Length` headers. Stream bodies are best suited for HTTP messages with `Transfer-Encoding` set to `chunked`.

## Storage

The `Storage` type represents arbitrary data that can be passed between middleware and a responder in a chain.

```swift
public typealias Storage = [String: Any]
```

### Motivation

Having a storage in the HTTP messages makes middleware much more useful since they can pass forward parsed/serialized content, session information or just about any custom data.

## HTTPMessage

The `HTTPMessage` protocol represents properties common to HTTP messages (request/response).

```swift
public protocol HTTPMessage {
    var version: HTTPVersion { get set }
    var headers: HTTPHeaders { get set }
    var body: HTTPBody { get set }
    var storage: Storage { get set }
}
```

### Motivation

Having the `HTTPMessage` protocol makes adding computed properties common to requests and responses more convenient. It removes code duplication.

## HTTPMethod

The `HTTPMethod` type represents an HTTP method.

```swift
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
```

### Motivation

Having `HTTPMethod` as an enum with a `Raw` case makes it convenient and flexible at the same time. Also protocols can't be used as a key to a dictionary and this could be common.

## URI

The `URI` type represents an URI.

```swift
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
```

### Motivation

Having `URI` as a `struct` allows it to conform to protocols in extensions.

## HTTPRequest

The `HTTPRequest` type represents an HTTP request.

```swift
public struct HTTPRequest: HTTPMessage {
    public var method: HTTPMethod
    public var uri: URI
    public var version: HTTPVersion
    public var headers: HTTPHeaders
    public var body: HTTPBody
    public var storage: Storage = [:]
}
```

### Motivation

Having `HTTPRequest` as a `struct` allows it to conform to protocols in extensions.

## HTTPRequestParser

The `HTTPRequestParser` protocol represents a type that can parse an HTTP request from binary data.

```swift
public protocol HTTPRequestParser {
    func parse(data: Data) throws -> HTTPRequest?
}
```

## HTTPRequestSerializer

The `HTTPRequestSerializer` protocol represents a type that can serialize HTTP requests to binary data.

```swift
public protocol HTTPRequestSerializer {
    func serialize(request: HTTPRequest, @noescape send: Data throws -> Void) throws
}
```

## HTTPStatus

The `HTTPStatus` protocol represents an HTTP status.

```swift
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
```

### Motivation

Having `HTTPStatus` as an enum with a `Raw` case makes it convenient and flexible at the same time.

## HTTPResponse

The `HTTPResponse` type represents an HTTP response.

```swift
public struct HTTPResponse: HTTPMessage {
    public var version: HTTPVersion
    public var status: HTTPStatus
    public var headers: HTTPHeaders
    public var body: HTTPBody
    public var storage: Storage = [:]
}
```

### Motivation

Having `HTTPResponse` as a `struct` allows it to conform to protocols in extensions.

## HTTPResponseParser

The `HTTPResponseParser` protocol represents a type that can parse an HTTP response.

```swift
public protocol HTTPResponseParser {
    func parse(data: Data) throws -> HTTPResponse?
}
```

## HTTPResponseSerializer

The `HTTPResponseSerializer` protocol represents a type that can serialize HTTP responses.

```swift
public protocol HTTPResponseSerializer {
    func serialize(response: HTTPResponse, @noescape send: Data throws -> Void) throws
}
```

## HTTPResponder

The `HTTPResponder` protocol represents a type that can respond to HTTP requests.

```swift
public protocol HTTPResponder {
    func respond(request: HTTPRequest) throws -> HTTPResponse
}
```

### Motivation

This is the most important protocol in an HTTP context. The responder is the base for higher-level abstractions like routers and middlewares.

## HTTPMiddleware

The `HTTPMiddleware` protocol represents a type that responds to an HTTP request optionally forwarding the request to the chain.


```swift
public protocol HTTPMiddleware {
    func respond(request: HTTPRequest, chain: HTTPResponder) throws -> HTTPResponse
}
```

### Motivation

Middleware drastically reduces boilerplate and allows code reuse. This degisn allows middleware to be applied on the server and on the client, reducing boilerplate even further.

## HTTPClient

The `HTTPClient` protocol represents a type that sends HTTP requests by:

- Making a connection
- Serializing the HTTP request
- Parsing the HTTP response

```swift
public protocol HTTPClient: HTTPResponder {
    var client: StreamClient { get }
    var serializer: HTTPRequestSerializer { get }
    var parser: HTTPResponseParser { get }
}
```

## HTTPServer

The `HTTPServer` protocol represents a type that serves HTTP requests by:

- Accepting a connection
- Parsing the HTTP request
- Responding the HTTP request
- Serializing the HTTP response

```swift
public protocol HTTPServer {
    var server: StreamServer { get }
    var parser: HTTPRequestParser { get }
    var responder: HTTPResponder { get }
    var serializer: HTTPResponseSerializer  { get }
}
```

## HTTPRoute

The `HTTPRoute` protocol represents an HTTP route.

```swift
public protocol HTTPRoute: HTTPResponder {
    var path: String { get }
    var actions: [HTTPMethod: HTTPResponder] { get }
    var fallback: HTTPResponder { get }
}
```

### Motivation

This design makes the router's job easier. The router only needs to match the request's `path` to a route's `path`. The route itself will know if it has a responder for that method. If it doesn't, it responds with the fallback which could default to `MethodNotAllowed`.

This could be done with a protocol extension implementing `respond` from the `HTTPResponder` protocol.

```swift
extension HTTPRoute {
    public func respond(request: HTTPRequest) throws -> HTTPResponse {
        let action = actions[request.method] ?? fallback
        return try action.respond(request)
    }
}
```

## HTTPRouter

The `HTTPRouter` protocol represents an HTTP router.

```swift
public protocol HTTPRouter: HTTPResponder {
    var routes: [HTTPRoute] { get }
    var fallback: HTTPResponder { get }
    func match(request: HTTPRequest) -> HTTPRoute?
}
```

### Motivation

`HTTPRouter` being an `HTTPResponder` the `respond` function could simply be:

```swift
extension HTTPRouter {
    public func respond(request: HTTPRequest) throws -> HTTPResponse {
        let responder = match(request) ?? fallback
        return try responder.respond(request)
    }
}
```