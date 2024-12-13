public struct HackAssembler {
    
    var symbols = SymbolTable()
    var instructions: [Instruction] = []
    var output: [String] = []

    public init() { }
    
    public mutating func translate(assembly: String) -> [String] {
        parse(assembly)
        firstPass()
        secondPass()
        return output
    }

    mutating func parse(_ source: String) {
        let parser = Parser()
        instructions = source
            .split(whereSeparator: \.isNewline)
            .map(String.init)
            .compactMap(parser.parse)
    }

    mutating func firstPass() {
        var nextLine = 0
        for instruction in instructions {
            switch instruction {
            case .label(let label):
                symbols.addLabel(label, address: nextLine)
            default:
                nextLine += 1
            }
        }
    }

    mutating func secondPass() {
        var encoder = Encoder(symbols)
        output = instructions.compactMap {
            encoder.encode($0)
        }
    }
}
