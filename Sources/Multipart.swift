public enum MultiPart: Node {
    case files([(filename: String?, mediaType: (type: String, subtype: String)?, data: Data)])
    case file(filename: String?, mediaType: (type: String, subtype: String)?, data: Data)
    case input(String)
    case inputArray([String])
}