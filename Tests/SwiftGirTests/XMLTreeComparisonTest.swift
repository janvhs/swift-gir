import SWXMLHash
import XCTest

final class XMLTreeComparisonTest: XCTestCase {
    func testSame() throws {
        let correctFile = URL(
            filePath: "TestData/TreeComparison/correct.xml",
            relativeTo: URL(filePath: #file))

        let stillCorrectFile = correctFile

        let areSame = try compareXMLFiles(originalFile: correctFile, replicatedFile: stillCorrectFile)

        XCTAssert(areSame)
    }

    func testLessAttributes() throws {
        let correctFile = URL(
            filePath: "TestData/TreeComparison/correct.xml",
            relativeTo: URL(filePath: #file))

        let wrongFile = URL(
            filePath: "TestData/TreeComparison/less_attributes.xml",
            relativeTo: URL(filePath: #file))

        let areSame = try compareXMLFiles(originalFile: correctFile, replicatedFile: wrongFile)

        XCTAssert(!areSame)
    }

    func testLessElements() throws {
        let correctFile = URL(
            filePath: "TestData/TreeComparison/correct.xml",
            relativeTo: URL(filePath: #file))

        let wrongFile = URL(
            filePath: "TestData/TreeComparison/less_elements.xml",
            relativeTo: URL(filePath: #file))

        let areSame = try compareXMLFiles(originalFile: correctFile, replicatedFile: wrongFile)

        XCTFail("It should print the name of the missing node")
        XCTAssert(!areSame)
    }

    func testMoreAttributes() throws {
        let correctFile = URL(
            filePath: "TestData/TreeComparison/correct.xml",
            relativeTo: URL(filePath: #file))

        let wrongFile = URL(
            filePath: "TestData/TreeComparison/more_attributes.xml",
            relativeTo: URL(filePath: #file))

        let areSame = try compareXMLFiles(originalFile: correctFile, replicatedFile: wrongFile)

        // TODO: When the replicated tree has more argument's it doesen't get recognized, yet
        XCTAssert(!areSame)
    }

    func testMoreElements() throws {
        let correctFile = URL(
            filePath: "TestData/TreeComparison/correct.xml",
            relativeTo: URL(filePath: #file))

        let wrongFile = URL(
            filePath: "TestData/TreeComparison/more_elements.xml",
            relativeTo: URL(filePath: #file))

        let areSame = try compareXMLFiles(originalFile: correctFile, replicatedFile: wrongFile)

        // TODO: Print the names of the nodes, which are not in the original.
        XCTAssert(!areSame)
    }

    func testUnexpectedCollection() throws {
        let correctFile = URL(
            filePath: "TestData/TreeComparison/correct.xml",
            relativeTo: URL(filePath: #file))

        let wrongFile = URL(
            filePath: "TestData/TreeComparison/collection_element.xml",
            relativeTo: URL(filePath: #file))

        let areSame = try compareXMLFiles(originalFile: correctFile, replicatedFile: wrongFile)

        // TODO: Print the names of the nodes, which are not in the original.
        XCTAssert(!areSame)
    }

    func testMissingCollection() throws {
        let correctFile = URL(
            filePath: "TestData/TreeComparison/correct.xml",
            relativeTo: URL(filePath: #file))

        let wrongFile = URL(
            filePath: "TestData/TreeComparison/not_collection_element.xml",
            relativeTo: URL(filePath: #file))

        let areSame = try compareXMLFiles(
            originalFile: correctFile,
            replicatedFile: wrongFile)

        XCTFail("Not the same but still somehow valid")
        XCTAssert(!areSame)
    }

    func testMissingOptionalAttribute() throws {
        let correctFile = URL(
            filePath: "TestData/TreeComparison/correct.xml",
            relativeTo: URL(filePath: #file))

        let wrongFile = URL(
            filePath: "TestData/TreeComparison/not_optional_attribute.xml",
            relativeTo: URL(filePath: #file))

        let areSame = try compareXMLFiles(
            originalFile: correctFile,
            replicatedFile: wrongFile)

        XCTFail("Not the same but still valid")
        XCTAssert(!areSame)
    }

    func testMissingOptionalElement() throws {
        let correctFile = URL(
            filePath: "TestData/TreeComparison/correct.xml",
            relativeTo: URL(filePath: #file))

        let wrongFile = URL(
            filePath: "TestData/TreeComparison/not_optional_element.xml",
            relativeTo: URL(filePath: #file))

        let areSame = try compareXMLFiles(originalFile: correctFile, replicatedFile: wrongFile)

        XCTFail("Not the same but still valid")
        XCTAssert(!areSame)
    }
}
