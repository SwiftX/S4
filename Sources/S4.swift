@_exported import C7

#if swift(>=3.0)
#else
    public typealias ErrorProtocol = ErrorType
    public typealias RangeReplaceableCollection = RangeReplaceableCollectionType
    public typealias MutableCollection = MutableCollectionType
    public typealias Sequence = SequenceType
#endif
