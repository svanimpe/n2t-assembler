struct Encoder {

    var symbols: SymbolTable

    init(_ symbols: SymbolTable) {
        self.symbols = symbols
    }

    mutating func encode(_ instruction: Instruction) -> String? {
        switch instruction {
        case .a(let value):
            if let constant = Int(value) {
                let bits = String(constant, radix: 2).suffix(15)
                return String(repeating: "0", count: 16 - bits.count) + bits
            }
            if symbols[value] == nil {
                symbols.addVariable(value)
            }
            return encode(.a(String(symbols[value]!)))
        case .c(let dest, let comp, let jump):
            return "111\(encodeComp(comp))\(encodeDest(dest))\(encodeJump(jump))"
        default:
            return nil
        }
    }

    func encodeComp(_ comp: String) -> String {
        let comp = comp.replacing(" ", with: "")
        switch comp {
        case "0":
            return "0101010"
        case "1":
			return "0111111"
        case "-1":
			return "0111010"
        case "D":
			return "0001100"
        case "A":
			return "0110000"
        case "M":
			return "1110000"
        case "!D":
			return "0001101"
        case "!A":
			return "0110001"
        case "!M":
			return "1110001"
        case "-D":
			return "0001111"
        case "-A":
			return "0110011"
        case "-M":
			return "1110011"
        case "D+1":
			return "0011111"
        case "A+1":
			return "0110111"
        case "M+1":
			return "1110111"
        case "D-1":
			return "0001110"
        case "A-1":
			return "0110010"
        case "M-1":
			return "1110010"
        case "D+A":
			return "0000010"
        case "D+M":
			return "1000010"
        case "D-A":
			return "0010011"
        case "D-M":
			return "1010011"
        case "A-D":
			return "0000111"
        case "M-D":
			return "1000111"
        case "D&A":
			return "0000000"
        case "D&M":
			return "1000000"
        case "D|A":
			return "0010101"
        case "D|M":
			return "1010101"
        default:
            fatalError("unknown computation \(comp)")
        }
    }

    func encodeDest(_ dest: String?) -> String {
        switch dest {
        case "M":   "001"
        case "D":   "010"
        case "MD":  "011"
        case "A":   "100"
        case "AM":  "101"
        case "AD":  "110"
        case "AMD": "111"
        default:    "000"
        }
    }

    func encodeJump(_ jump: String?) -> String {
        switch jump {
        case "JGT": "001"
        case "JEQ": "010"
        case "JGE": "011"
        case "JLT": "100"
        case "JNE": "101"
        case "JLE": "110"
        case "JMP": "111"
        default:    "000"
        }
    }
}
