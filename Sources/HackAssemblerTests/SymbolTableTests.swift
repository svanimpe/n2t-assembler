import Testing
@testable import HackAssembler

struct SymbolTableTests {

    var table = SymbolTable()

    @Test
    mutating func addVariable() {
        table.addVariable("x")
        #expect(table["x"] == 16)
        table.addVariable("y")
        #expect(table["y"] == 17)
        table.addVariable("z")
        #expect(table["z"] == 18)
    }

    @Test
    mutating func addLabel() {
        table.addLabel("LOOP", address: 42)
        #expect(table["LOOP"] == 42)
    }
}
