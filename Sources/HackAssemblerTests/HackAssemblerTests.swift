import Foundation
import Testing
@testable import HackAssembler

struct HackAssemblerTests {

    var hasm = HackAssembler()

    @Test
    mutating func parse() {
        hasm.parse("""
        (START)
            @i
            M=1
        """)
        #expect(hasm.instructions == [
            .label("START"),
            .a("i"),
            .c(dest: "M", comp: "1")
        ])
    }

    @Test
    mutating func firstPass() {
        hasm.instructions = [
            .label("START"),
            .a("i"),
            .c(dest: "M", comp: "1"),
            .label("END")
        ]
        hasm.firstPass()
        #expect(hasm.symbols["START"] == 0)
        #expect(hasm.symbols["END"] == 2)
    }

    @Test
    mutating func secondPass() {
        hasm.instructions = [
            .label("START"),
            .a("i"),
            .c(dest: "M", comp: "1"),
        ]
        hasm.secondPass()
        #expect(hasm.output == [
            "0000000000010000",
            "1110111111001000"
        ])
    }

    @Test(arguments: [
        "Add",
        "Max",
        "Rect",
        "Pong"
    ])
    mutating func translate(file: String) throws {
        let asm = Bundle.module.url(forResource: file, withExtension: "asm")!
        let output = hasm.translate(assembly: try String(contentsOf: asm, encoding: .utf8))
        let hack = Bundle.module.url(forResource: file, withExtension: "hack")!
        let expectedOutput = try String(contentsOf: hack, encoding: .utf8)
        #expect(output.joined(separator: "\n") == expectedOutput)
    }
}
