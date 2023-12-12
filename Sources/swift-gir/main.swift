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
import XMLCoder

struct Hello: Codable {
    let hello: String
}

@main
struct Repeat: ParsableCommand {
    @Argument(help: "The GIR file to convert")
    var file: String

    mutating func run() throws {
        let hello = Hello(hello: file)
        let encoded = try XMLCoder.XMLEncoder().encode(hello)
        let data = String(decoding: encoded, as: UTF8.self)

        print(data)
    }
}
