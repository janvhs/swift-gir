import XMLCoder

public struct GIRepository: Codable {
    @Attribute public private(set) var xmlns: String
    @Attribute public private(set) var xmlnsC: String
    @Attribute public private(set) var xmlnsGLib: String
    @Attribute public private(set) var version: Float

    @Element public private(set) var package: GIPackage
    @Element public private(set) var cInclude: GICInclude
    @Element public private(set) var namespace: GINamespace

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
}

public struct GIPackage: Codable {
    @Attribute public private(set) var name: String
}

public struct GICInclude: Codable {
    @Attribute public private(set) var name: String
}

public struct GINamespace: Codable {
    @Attribute public private(set) var name: String
    @Attribute public private(set) var version: Float
    @Attribute public private(set) var sharedLibrary: String
    @Attribute public private(set) var cIdentifierPrefixes: String
    @Attribute public private(set) var cSymbolPrefixes: String

    @Element public private(set) var alias: GIAlias

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
}

public struct GIAlias: Codable {
    @Attribute public private(set) var name: String
    @Attribute public private(set) var cType: String

    @Element public private(set) var doc: GIDoc
    @Element public private(set) var type: GIType

    enum CodingKeys: String, CodingKey {
        // Attributes
        case name
        case cType = "c:type"

        // Elements
        case doc
        case type
    }
}

public struct GIDoc: Codable {
    // TODO(janvhs): this should probably be an enum
    @Attribute public private(set) var xmlSpace: String

    @Element public private(set) var value: String

    enum CodingKeys: String, CodingKey {
        // Attributes
        case xmlSpace = "xml:space"

        // Elements
        case value = ""
    }
}

public struct GIType: Codable {
    @Attribute public private(set) var name: String
    @Attribute public private(set) var cType: String

    enum CodingKeys: String, CodingKey {
        // Attributes
        case name
        case cType = "c:type"
    }
}
