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
import SwiftGir

@main
struct Generate: ParsableCommand {
    @Argument(help: "The GIR file to convert")
    var girFile: String

    @Argument(help: "Where to put the generated Swift files", completion: .directory)
    var out: String = "-"

    mutating func run() throws {
        let girFileURL = URL(filePath: girFile)
        let girContents = try Data(contentsOf: girFileURL)
        let decoder = GIDecoder()

        let repo = try decoder.decode(girContents)

        print(repo.version)
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
