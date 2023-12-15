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
import SWXMLHash
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
        let originalXMLTree = SWXMLHash.XMLHash.lazy(girContents)
        let decoder = GIDecoder()

        let gir = try decoder.decode(girContents)

        let girHeader = XMLCoder.XMLHeader(version: 1.0)
        let girEncoder = XMLCoder.XMLEncoder()
        let reEncodedContents = try girEncoder.encode(gir, withRootKey: "repository", header: girHeader)
        let reEncodedXMLTree = SWXMLHash.XMLHash.lazy(reEncodedContents)

        let areEqual = dfsComparison(original: originalXMLTree, copy: reEncodedXMLTree)
        print("The re-encoding was \(areEqual ? "successful" : "not successful")")
    }
}

// TODO(janvhs): Move to tests and add tests for the different scenarios.
func dfsComparison(original: XMLIndexer, copy: XMLIndexer) -> Bool {
    // Check if they have the same amount of children
    // TODO(janvhs): When calculating differences, this has to be removed
    guard original.children.count == copy.children.count else {
        if original.children.count > copy.children.count {
            print("""
            The original tree, at <\(original.element?.name ?? "unknown") /> ,
            has more nodes (\(original.children.count)) than the re-encoded tree
            """)
        } else {
            print("""
            The re-encoded tree, at <\(copy.element?.name ?? "unknown") />,
            has more nodes (\(copy.children.count)) than the original tree
            """)
        }

        return false
    }

    // Go through each child, ...
    for (originalIdx, originalChildTree) in original.children.enumerated() {
        // FIXME(janvhs): If tests flaky, order of attributes is not guaranteed, why should the order of children be?
        let copyChildTree = copy.children[originalIdx]

        // If the child node tree of the original data has more children nodes,
        // they have to be handled first.
        // TODO(janvhs): Warn by count differences
        if originalChildTree.children.count > 0 {
            return dfsComparison(original: originalChildTree, copy: copyChildTree)
        }

        // check if they booth have an element, ...
        guard let originalChild = originalChildTree.element,
              let copyChild = copyChildTree.element
        else {
            print("getting children element at index \(originalIdx) failed")
            return false
        }

        // ... compare their attributes and ...
        // The order of attributes is not guaranteed
        for (originalKey, originalAttribute) in originalChild.allAttributes {
            let copyAttribute = copyChild.allAttributes[originalKey]

            guard let copyAttribute else {
                print("Key \"\(originalKey)\" on element <\(copyChild.name) /> not implemented")
                return false
            }

            guard originalAttribute.name == copyAttribute.name,
                  originalAttribute.text == copyAttribute.text
            else {
                print("Attributes of element <\(copyChild.name) /> != original <\(originalChild.name) />")
                print("  Original: \(originalAttribute.name) = \(originalAttribute.text)")
                print("  Copy:     \(copyAttribute.name) = \(copyAttribute.text)")
                return false
            }
        }

        // ... compare their values.
        guard originalChild.text.trimmingCharacters(in: .whitespacesAndNewlines)
            == copyChild.text.trimmingCharacters(in: .whitespacesAndNewlines)
        else {
            print("Value of element <\(copyChild.name) /> != original <\(originalChild.name) />")
            print("  Original: |\(originalChild.text)|")
            print("  Copy:     |\(copyChild.text)|")
            return false
        }
    }

    return true
}

// TODO(janvhs): Add functionality to XMLCodable, for a simpler API.
// struct GIAlias: Codable {
//     @Attribute var name: String
//     @Attribute(name: "c:type") var cType: String
//
//     @Element var doc: String
//     @Element var type: GIType
// }
