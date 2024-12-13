import ArgumentParser
import HackAssembler

@main
struct HASM: ParsableCommand {

    @Argument(
        help: "A Hack assembly file.",
        completion: .file(extensions: ["asm"])
    )
    var inputFile: String

    func run() throws {
        var assembler = HackAssembler()
        let input = try String(contentsOfFile: inputFile, encoding: .utf8)
        let output = assembler.translate(assembly: input)
        let outputFile = inputFile.replacing(".asm", with: ".hack")
        try output
            .joined(separator: "\n")
            .write(toFile: outputFile, atomically: true, encoding: .utf8)
    }
}
