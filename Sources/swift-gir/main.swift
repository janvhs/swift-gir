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

        decoder.keyDecodingStrategy = .custom(decodeGIRKey)

        let repo = try decoder.decode(GIRepository.self, from: girContents)
        print(repo)
    }
}

// TODO(janvhs): Add functionality to XMLCodable, so I can remove func decodeGIRKey.
// struct GIAlias: Codable {
//     @Attribute var name: String
//     @Attribute(name: "c:type") var cType: String
//
//     @Element var doc: String
//     @Element var type: GIType
// }

// TODO(janvhs): To fully fit in Swift's naming convention, one could uppercase abbr. like url to URL.
/// Decode the GIR-XML Keys to fit Swift's naming conventions.
/// This has to be done to represent keys containing hyphens
/// and colons on Swift's structs.
func decodeGIRKey(_ keys: [CodingKey]) -> CodingKey {
    // Panic, if there is no key
    let key = keys.last!

    // If the key contains a hyphen or colon, convert it to camelCase
    var keyParts = key.stringValue.split(separator: "-")
        .flatMap { part in
            part.split(separator: ":")
        }

    // The head has to stay lower cased
    let casedKeyHead = if keyParts.count > 0 {
        String(keyParts.removeFirst())
    } else {
        ""
    }

    // The rest of the body has to be KebabCased
    let casedKeyRest = keyParts.map { part in
        part.capitalized
    }.joined()

    let casedKey = String(casedKeyHead + casedKeyRest)

    return XMLKey(stringValue: casedKey, intValue: key.intValue)
}

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
    // Attributes
    let xmlns: URL
    var xmlnsC: URL
    let xmlnsGlib: URL
    let version: Float

    // Elements
    let package: GIPackage
    let cInclude: GICInclude
    let namespace: GINamespace
}

struct GIPackage: Codable {
    // Attributes
    let name: String
}

struct GICInclude: Codable {
    // Attributes
    let name: String
}

struct GINamespace: Codable {
    // Attributes
    let name: String
    let version: Float
    let sharedLibrary: String
    let cIdentifierPrefixes: String
    let cSymbolPrefixes: String

    // Elements
    let alias: GIAlias
}

struct GIAlias: Codable {
    // Attributes
    let name: String
    let cType: String

    // Elements
    // TODO(janvhs): Make a GIDoc struct
    let doc: String
    let type: GIType
}

struct GIType: Codable {
    let name: String
    let cType: String
}
