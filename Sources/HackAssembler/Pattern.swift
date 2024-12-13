import RegexBuilder

enum Pattern {
    // Text beginning with two slashes (//) and ending at the end of the line is
    // considered a comment and is ignored.
    static let comment = Regex {
        "//"
        ZeroOrMore(.any)
        Anchor.endOfLine
    }

    // Set of characters allowed in a symbol.
    static let allowedSymbolCharacters = CharacterClass(
        .generalCategory(.uppercaseLetter),
        .generalCategory(.lowercaseLetter),
        .digit,
        .anyOf("_.$:")
    )

    // A user-defined symbol can be any sequence of letters, digits, underscore (_),
    // dot (.), dollar sign ($), and colon (:) that does not begin with a digit.
    static let symbol = Regex {
        One(allowedSymbolCharacters.subtracting(.digit))
        ZeroOrMore(allowedSymbolCharacters)
    }

    // A-instruction that contains either a constant or a symbol.
    static let aInstruction = Regex {
        ZeroOrMore(.whitespace)
        "@"
        Capture {
            ChoiceOf {
                OneOrMore(.digit)
                symbol
            }
        }
        ZeroOrMore(.whitespace)
        Optionally {
            comment
        }
    }

    // Destination part of a C-instruction.
    static let destination = Regex {
        Capture {
            ChoiceOf {
                "M"
                "D"
                "MD"
                "A"
                "AM"
                "AD"
                "AMD"
            }
        }
        ZeroOrMore(.whitespace)
        "="
    }

    // Computation part of a C-instruction.
    static let computation = Regex {
        Capture {
            ChoiceOf {
                "0"
                "1"
                "-1"
                "D"
                "A"
                "M"
                "!D"
                "!A"
                "!M"
                "-D"
                "-A"
                "-M"
                Regex {
                    ChoiceOf {
                        "D"
                        "A"
                        "M"
                    }
                    ZeroOrMore(.whitespace)
                    ChoiceOf {
                        "+"
                        "-"
                    }
                    ZeroOrMore(.whitespace)
                    "1"
                }
                Regex {
                    "D"
                    ZeroOrMore(.whitespace)
                    ChoiceOf {
                        "+"
                        "-"
                        "&"
                        "|"
                    }
                    ZeroOrMore(.whitespace)
                    ChoiceOf {
                        "A"
                        "M"
                    }
                }
                Regex {
                    ChoiceOf {
                        "A"
                        "M"
                    }
                    ZeroOrMore(.whitespace)
                    "-"
                    ZeroOrMore(.whitespace)
                    "D"
                }
            }
        }
    }

    // Jump part of a C-instruction.
    static let jump = Regex {
        ";"
        ZeroOrMore(.whitespace)
        Capture {
            ChoiceOf {
                "JGT"
                "JEQ"
                "JGE"
                "JLT"
                "JNE"
                "JLE"
                "JMP"
            }
        }
    }

    // C-instruction with optional destination and jump parts.
    static let cInstruction = Regex {
        ZeroOrMore(.whitespace)
        Optionally {
            destination
        }
        ZeroOrMore(.whitespace)
        computation
        ZeroOrMore(.whitespace)
        Optionally {
            jump
        }
        ZeroOrMore(.whitespace)
        Optionally {
            comment
        }
    }

    // Label pseudo-instruction.
    static let label = Regex {
        ZeroOrMore(.whitespace)
        "("
        ZeroOrMore(.whitespace)
        Capture {
            symbol
        }
        ZeroOrMore(.whitespace)
        ")"
        ZeroOrMore(.whitespace)
        Optionally {
            comment
        }
    }
}
