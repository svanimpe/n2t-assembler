import Testing
@testable import HackAssembler

struct EncoderTests {

    var encoder: Encoder

    init() {
        var symbols = SymbolTable()
        symbols.addLabel("START", address: 1)
        encoder = Encoder(symbols)
    }

    @Test(arguments: [
        (Instruction.a("0"),                        "0000000000000000"),
        (.a("16"),                                  "0000000000010000"),
        (.a("START"),                               "0000000000000001"),
        (.a("i"),                                   "0000000000010000"),
        (.c(dest:"AMD", comp: "1", jump: "JMP"),    "1110111111111111"),
        (.c(dest: "D", comp: "M"),                  "1111110000010000"),
        (.c(comp: "D", jump: "JEQ"),                "1110001100000010"),
    ])
    mutating func encode(instruction: Instruction, expectedOutput: String) {
        let output = encoder.encode(instruction)
        #expect(output == expectedOutput)
    }
}
