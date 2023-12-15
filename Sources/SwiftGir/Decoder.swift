import SecurityFoundation
import XMLCoder

/// Decodes the given GIR Data into it's corresponding structural representation.
public struct GIDecoder {
    let xmlDecoder: XMLDecoder

    public init() {
        xmlDecoder = XMLDecoder()
    }

    public func decode(_ from: Data) throws -> GIRepository {
        try xmlDecoder.decode(GIRepository.self, from: from)
    }
}
