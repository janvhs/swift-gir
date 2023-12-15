//
// SwiftGir - Convert GIR files to their Swift source representation.
// Copyright (C) 2023  Jan Fooken (https://janvhs.com)
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301
// USA
//

// The Swift Programming Language
// https://docs.swift.org/swift-book

import ArgumentParser
import Foundation
import XMLCoder

@main
struct Generate: ParsableCommand {
    @Argument(help: "The GIR file to convert")
    var girFile: String

    @Argument(help: "Where to put the generated Swift files", completion: .directory)
    var out: String = "-"

    mutating func run() throws {
        let girFileURL = URL(filePath: girFile)
        let girContents = try Data(contentsOf: girFileURL)
        let decoder = XMLDecoder()

        let repo = try decoder.decode(GIRepository.self, from: girContents)

        let encoder = XMLEncoder()
        encoder.prettyPrintIndentation = .spaces(2)

        let encodedGIR = try encoder.encode(repo, withRootKey: "repository", header: XMLHeader(version: 1.0))

        if out == "-" {
            let girXMLText = String(data: encodedGIR, encoding: .utf8)
            guard let girXMLText else {
                return
            }

            print(girXMLText)
        } else {
            let outURL = URL(filePath: out)
            try encodedGIR.write(to: outURL)
        }
    }
}

// TODO(janvhs): Add functionality to XMLCodable, for a simpler API.
// struct GIAlias: Codable {
//     @Attribute var name: String
//     @Attribute(name: "c:type") var cType: String
//
//     @Element var doc: String
//     @Element var type: GIType
// }

// Taken from https://github.com/CoreOffice/XMLCoder
// TODO(janvhs): Maybe just extend String with CodingKey
/// Shared Key Types
struct XMLKey: CodingKey {
    public let stringValue: String
    public let intValue: Int?

    public init?(stringValue: String) {
        self.init(key: stringValue)
    }

    public init?(intValue: Int) {
        self.init(index: intValue)
    }

    public init(stringValue: String, intValue: Int?) {
        self.stringValue = stringValue
        self.intValue = intValue
    }

    init(key: String) {
        self.init(stringValue: key, intValue: nil)
    }

    init(index: Int) {
        self.init(stringValue: "\(index)", intValue: index)
    }

    static let `super` = XMLKey(stringValue: "super")!
}

struct GIRepository: Codable {
    @Attribute var xmlns: String
    @Attribute var xmlnsC: String
    @Attribute var xmlnsGLib: String
    @Attribute var version: Float

    @Element var package: GIPackage
    @Element var cInclude: GICInclude
    @Element var namespace: GINamespace

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

struct GIPackage: Codable {
    @Attribute var name: String
}

struct GICInclude: Codable {
    @Attribute var name: String
}

struct GINamespace: Codable {
    @Attribute var name: String
    @Attribute var version: Float
    @Attribute var sharedLibrary: String
    @Attribute var cIdentifierPrefixes: String
    @Attribute var cSymbolPrefixes: String

    @Element var alias: GIAlias

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

struct GIAlias: Codable {
    @Attribute var name: String
    @Attribute var cType: String

    @Element var doc: GIDoc
    @Element var type: GIType

    enum CodingKeys: String, CodingKey {
        // Attributes
        case name
        case cType = "c:type"

        // Elements
        case doc
        case type
    }
}

struct GIDoc: Codable {
    // TODO(janvhs): this should probably be an enum
    @Attribute var xmlSpace: String

    @Element var value: String

    enum CodingKeys: String, CodingKey {
        // Attributes
        case xmlSpace = "xml:space"

        // Elements
        case value = ""
    }
}

struct GIType: Codable {
    @Attribute var name: String
    @Attribute var cType: String

    enum CodingKeys: String, CodingKey {
        // Attributes
        case name
        case cType = "c:type"
    }
}
