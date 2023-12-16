import SecurityFoundation
import SWXMLHash

// TODO(janvhs): Add tests for the different scenarios.
func compareXMLTree(original: XMLIndexer, replicated: XMLIndexer) -> Bool {
    // Check if they have the same amount of children
    // TODO(janvhs): When calculating differences, this has to be replaced
    guard original.children.count == replicated.children.count else {
        if original.children.count > replicated.children.count {
            print("""
            The original tree, at <\(original.element?.name ?? "unknown") /> ,
            has more nodes (\(original.children.count - replicated.children.count)) than the replicated tree
            """)
        } else {
            print("""
            The replicated tree, at <\(replicated.element?.name ?? "unknown") />,
            has more nodes (\(replicated.children.count - original.children.count)) than the original tree
            """)
        }

        return false
    }

    // Go through each child, ...
    for (originalIdx, originalChildTree) in original.children.enumerated() {
        // FIXME(janvhs): If tests flaky, order of attributes is not guaranteed, why should the order of children be?
        let replicatedChildTree = replicated.children[originalIdx]

        // If the child node tree of the original data has more children nodes,
        // they have to be handled first.
        // TODO(janvhs): Warn by count differences
        if originalChildTree.children.count > 0 {
            return compareXMLTree(original: originalChildTree, replicated: replicatedChildTree)
        }

        // check if they booth have an element, ...
        guard let originalChild = originalChildTree.element,
              let replicatedChild = replicatedChildTree.element
        else {
            print("Getting children element at index \(originalIdx) failed")

            return false
        }

        // ... compare their attributes and ...
        // The order of attributes is not guaranteed
        for (originalKey, originalAttribute) in originalChild.allAttributes {
            let replicatedAttribute = replicatedChild.allAttributes[originalKey]

            guard let replicatedAttribute else {
                print("Key \"\(originalKey)\" on element <\(replicatedChild.name) /> not implemented")

                return false
            }

            guard originalAttribute.name == replicatedAttribute.name,
                  originalAttribute.text == replicatedAttribute.text
            else {
                print("Attributes of element <\(replicatedChild.name) /> != original <\(originalChild.name) />")
                print("  Original:   \(originalAttribute.name) = \(originalAttribute.text)")
                print("  Replicated: \(replicatedAttribute.name) = \(replicatedAttribute.text)")

                return false
            }
        }

        // ... compare their values.
        guard originalChild.text.trimmingCharacters(in: .whitespacesAndNewlines)
            == replicatedChild.text.trimmingCharacters(in: .whitespacesAndNewlines)
        else {
            print("Value of element <\(replicatedChild.name) /> != original <\(originalChild.name) />")
            print("  Original:   |\(originalChild.text)|")
            print("  Replicated: |\(replicatedChild.text)|")

            return false
        }
    }

    return true
}

func compareXMLFiles(originalFile: URL, replicatedFile: URL) throws -> Bool {
    let originalContents = try Data(contentsOf: originalFile)
    let originalTree = SWXMLHash.XMLHash.lazy(originalContents)

    let replicatedContents = try Data(contentsOf: replicatedFile)
    let replicatedTree = SWXMLHash.XMLHash.lazy(replicatedContents)

    return compareXMLTree(original: originalTree, replicated: replicatedTree)
}
