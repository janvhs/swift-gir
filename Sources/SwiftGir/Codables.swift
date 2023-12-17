import XMLCoder

public struct GIRepository: Codable, DynamicNodeDecoding, DynamicNodeEncoding {
    // Attributes
    public let xmlns: String
    public let xmlnsC: String
    public let xmlnsGLib: String
    public let version: Float

    // Elements
    public let package: GIPackage
    public let cInclude: GICInclude
    public let namespace: GINamespace

    enum CodingKeys: String, CodingKey {
        // Attributes
        case xmlns
        case xmlnsC = "xmlns:c"
        case xmlnsGLib = "xmlns:glib"
        case version

        // Elements
        case package
        case cInclude = "c:include"
        case namespace
    }

    public static func nodeDecoding(for key: CodingKey) -> XMLCoder.XMLDecoder.NodeDecoding {
        switch key {
        // Attributes
        case CodingKeys.xmlns,
             CodingKeys.xmlnsC,
             CodingKeys.xmlnsGLib,
             CodingKeys.version: .attribute
        // Elements
        case CodingKeys.package,
             CodingKeys.cInclude,
             CodingKeys.namespace: .element
        // Only get's triggered, if a struct's member is not listed above
        default: fatalError("GIRepository: a struct's member is missing for decoding")
        }
    }

    public static func nodeEncoding(for key: CodingKey) -> XMLCoder.XMLEncoder.NodeEncoding {
        switch key {
        // Attributes
        case CodingKeys.xmlns,
             CodingKeys.xmlnsC,
             CodingKeys.xmlnsGLib,
             CodingKeys.version: .attribute
        // Elements
        case CodingKeys.package,
             CodingKeys.cInclude,
             CodingKeys.namespace: .element
        // Only get's triggered, if a struct's member is not listed above
        default: fatalError("GIRepository: a struct's member is missing for encoding")
        }
    }
}

public struct GIPackage: Codable, DynamicNodeDecoding, DynamicNodeEncoding {
    // Attributes
    public let name: String

    enum CodingKeys: String, CodingKey {
        // Attributes
        case name
    }

    public static func nodeDecoding(for key: CodingKey) -> XMLCoder.XMLDecoder.NodeDecoding {
        switch key {
        // Attributes
        case CodingKeys.name: .attribute
        // Only get's triggered, if a struct's member is not listed above
        default: fatalError("GIPackage: a struct's member is missing for decoding")
        }
    }

    public static func nodeEncoding(for key: CodingKey) -> XMLCoder.XMLEncoder.NodeEncoding {
        switch key {
        // Attributes
        case CodingKeys.name: .attribute
        // Only get's triggered, if a struct's member is not listed above
        default: fatalError("GIPackage: a struct's member is missing for encoding")
        }
    }
}

public struct GICInclude: Codable, DynamicNodeDecoding, DynamicNodeEncoding {
    // Attributes
    public let name: String

    enum CodingKeys: String, CodingKey {
        // Attributes
        case name
    }

    public static func nodeDecoding(for key: CodingKey) -> XMLCoder.XMLDecoder.NodeDecoding {
        switch key {
        // Attributes
        case CodingKeys.name: .attribute
        // Only get's triggered, if a struct's member is not listed above
        default: fatalError("GICInclude: a struct's member is missing for decoding")
        }
    }

    public static func nodeEncoding(for key: CodingKey) -> XMLCoder.XMLEncoder.NodeEncoding {
        switch key {
        // Attributes
        case CodingKeys.name: .attribute
        // Only get's triggered, if a struct's member is not listed above
        default: fatalError("GICInclude: a struct's member is missing for encoding")
        }
    }
}

public struct GINamespace: Codable, DynamicNodeDecoding, DynamicNodeEncoding {
    // Attributes
    public let name: String
    public let version: Float
    public let sharedLibrary: String
    public let cIdentifierPrefixes: String
    public let cSymbolPrefixes: String

    // Elements
    public let alias: GIAlias

    enum CodingKeys: String, CodingKey {
        // Attributes
        case name
        case version
        case sharedLibrary = "shared-library"
        case cIdentifierPrefixes = "c:identifier-prefixes"
        case cSymbolPrefixes = "c:symbol-prefixes"

        // Elements
        case alias
    }

    public static func nodeDecoding(for key: CodingKey) -> XMLCoder.XMLDecoder.NodeDecoding {
        switch key {
        // Attributes
        case CodingKeys.name,
             CodingKeys.version,
             CodingKeys.sharedLibrary,
             CodingKeys.cIdentifierPrefixes,
             CodingKeys.cSymbolPrefixes: .attribute
        // Elements
        case CodingKeys.alias: .element
        // Only get's triggered, if a struct's member is not listed above
        default: fatalError("GINamespace: a struct's member is missing for decoding")
        }
    }

    public static func nodeEncoding(for key: CodingKey) -> XMLCoder.XMLEncoder.NodeEncoding {
        switch key {
        // Attributes
        case CodingKeys.name,
             CodingKeys.version,
             CodingKeys.sharedLibrary,
             CodingKeys.cIdentifierPrefixes,
             CodingKeys.cSymbolPrefixes: .attribute
        // Elements
        case CodingKeys.alias: .element
        // Only get's triggered, if a struct's member is not listed above
        default: fatalError("GINamespace: a struct's member is missing for encoding")
        }
    }
}

public struct GIAlias: Codable, DynamicNodeDecoding, DynamicNodeEncoding {
    // Attributes
    public let name: String
    public let cType: String

    // Elements
    public let doc: GIDoc
    public let type: GIType

    enum CodingKeys: String, CodingKey {
        // Attributes
        case name
        case cType = "c:type"

        // Elements
        case doc
        case type
    }

    public static func nodeDecoding(for key: CodingKey) -> XMLCoder.XMLDecoder.NodeDecoding {
        switch key {
        // Attributes
        case CodingKeys.name,
             CodingKeys.cType: .attribute
        // Elements
        case CodingKeys.doc,
             CodingKeys.type: .element
        // Only get's triggered, if a struct's member is not listed above
        default: fatalError("GIAlias: a struct's member is missing for decoding")
        }
    }

    public static func nodeEncoding(for key: CodingKey) -> XMLCoder.XMLEncoder.NodeEncoding {
        switch key {
        // Attributes
        case CodingKeys.name,
             CodingKeys.cType: .attribute
        // Elements
        case CodingKeys.doc,
             CodingKeys.type: .element
        // Only get's triggered, if a struct's member is not listed above
        default: fatalError("GIAlias: a struct's member is missing for encoding")
        }
    }
}

public struct GIDoc: Codable, DynamicNodeDecoding, DynamicNodeEncoding {
    // Attributes
    // TODO(janvhs): this should probably be an enum
    public let xmlSpace: String

    // Elements
    public let value: String

    enum CodingKeys: String, CodingKey {
        // Attributes
        case xmlSpace = "xml:space"

        // Elements
        case value = ""
    }

    public static func nodeDecoding(for key: CodingKey) -> XMLCoder.XMLDecoder.NodeDecoding {
        switch key {
        // Attributes
        case CodingKeys.xmlSpace: .attribute
        // Elements
        case CodingKeys.value: .element
        // Only get's triggered, if a struct's member is not listed above
        default: fatalError("GIDoc: a struct's member is missing for decoding")
        }
    }

    public static func nodeEncoding(for key: CodingKey) -> XMLCoder.XMLEncoder.NodeEncoding {
        switch key {
        // Attributes
        case CodingKeys.xmlSpace: .attribute
        // Elements
        case CodingKeys.value: .element
        // Only get's triggered, if a struct's member is not listed above
        default: fatalError("GIDoc: a struct's member is missing for encoding")
        }
    }
}

public struct GIType: Codable, DynamicNodeDecoding, DynamicNodeEncoding {
    // Attributes
    public let name: String
    public let cType: String

    enum CodingKeys: String, CodingKey {
        // Attributes
        case name
        case cType = "c:type"
    }

    public static func nodeDecoding(for key: CodingKey) -> XMLCoder.XMLDecoder.NodeDecoding {
        switch key {
        // Attributes
        case CodingKeys.name,
             CodingKeys.cType: .attribute
        // Only get's triggered, if a struct's member is not listed above
        default: fatalError("GIType: a struct's member is missing for decoding")
        }
    }

    public static func nodeEncoding(for key: CodingKey) -> XMLCoder.XMLEncoder.NodeEncoding {
        switch key {
        // Attributes
        case CodingKeys.name,
             CodingKeys.cType: .attribute
        // Only get's triggered, if a struct's member is not listed above
        default: fatalError("GIType: a struct's member is missing for encoding")
        }
    }
}
