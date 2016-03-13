# HTTPVersion

The `HTTPVersion` type represents an HTTP version.

```swift
public protocol HTTPVersion {
    var major: Int { get }
    var minor: Int { get }
}
```

## Motivation

HTTP version is needed to handle protocol differences properly.
