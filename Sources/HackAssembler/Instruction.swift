enum Instruction: Equatable {

    case a(String)
    case c(dest: String? = nil, comp: String, jump: String? = nil)
    case label(String)
}
