import AppKit
import ArgumentParser
import FlameGraphCore
import Foundation

struct InstrumentsFlameGraph: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "instruments-flamegraph",
        abstract: "Generates FlameGraphs from Xcode Instruments traces.")

    @Argument(help: "The path where the svg should be saves")
    var outputPath: String

    @Option(name: .shortAndLong, help: "The path of a txt that contains the trace copy")
    var input: String? = nil

    @Flag(name: .shortAndLong, help: "Don't open the file after generation")
    var silent = false

    func run() throws {
        let content: String
        let fromFile: Bool = !(input?.isEmpty == nil)
        if fromFile {
            do {
                print("📂 Load trace copy\n")
                content = try String(contentsOfFile: input!)
            } catch {
                throw LoadFileError(path: input!)
            }
        } else if let pasteBoardString = NSPasteboard.general.string(forType: .string) {
            content = pasteBoardString
        } else {
            throw MissingInputError.missingInputOrPasteboard
        }

        print("🔎 Parse trace copy\n")
        guard let callGraph = TraceParser.parse(content: content) else {
            if fromFile {
                throw ParsingFailedError(path: input!)
            } else {
                throw MissingInputError.missingInputOrPasteboard
            }
        }

        print("🔨 Generate Output\n")

        let output: RenderTarget

        output = SVGRender.render(graph: callGraph)

        print("💾 Save Output\n")
        do {
            try output.write(to: URL(fileURLWithPath: outputPath))
        } catch {
            throw SaveFileError(path: outputPath)
        }

        print("🔥 Successfully saved Output to \(String(describing: outputPath))\n")
        if silent == false {
            NSWorkspace.shared.openFile(outputPath)
        }
    }
}

InstrumentsFlameGraph.main()
