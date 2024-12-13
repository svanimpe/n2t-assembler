struct Parser {

    func parse(line: String) -> Instruction? {
        if let match = line.wholeMatch(of: Pattern.label) {
            return .label(String(match.output.1))
        } else if let match = line.wholeMatch(of: Pattern.aInstruction) {
            return .a(String(match.output.1))
        } else if let match = line.wholeMatch(of: Pattern.cInstruction) {
            return .c(
                dest: match.output.1 != nil ? String(match.output.1!) : nil,
                comp: String(match.output.2),
                jump: match.output.3 != nil ? String(match.output.3!) : nil
            )
        }
        return nil
    }
}
