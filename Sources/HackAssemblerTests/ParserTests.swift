import Testing
@testable import HackAssembler

struct ParserTests {

    let parser = Parser()

    @Test(arguments: [
        ("(LOOP)", Instruction.label("LOOP")),
        ("(A_B.1$2:3)", .label("A_B.1$2:3")),
        (" ( LOOP ) // comment", .label("LOOP")),
        ("@123", .a("123")),
        ("@a_B.1$2:3", .a("a_B.1$2:3")),
        (" @123 // comment", .a("123")),
        ("AMD=D+1;JEQ", .c(dest: "AMD", comp: "D+1", jump: "JEQ")),
        (" AMD = D + 1 ; JEQ // comment", .c(dest: "AMD", comp: "D + 1", jump: "JEQ")),
        ("D;JLT", .c(comp: "D", jump: "JLT")),
        (" D ; JLT ", .c(comp: "D", jump: "JLT")),
        ("A=A-1", .c(dest: "A", comp: "A-1")),
        (" A = A - 1 ", .c(dest: "A", comp: "A - 1"))
    ])
    func parseInstruction(line: String, expectedResult: Instruction?) {
        let result = parser.parse(line: line)
        #expect(result == expectedResult)
    }

    @Test(arguments: [
        "()",
        "@-1",
        "@1up",
        "D=JEQ",
        ";JEQ",
        "=D",
        "D;"
    ])
    func parseInvalid(line: String) {
        let result = parser.parse(line: line)
        #expect(result == nil)
    }
}
