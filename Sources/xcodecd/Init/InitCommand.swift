import ArgumentParser

extension Xcodecd {
    /// Prints shell helper definitions that integrate `xcodecd` with interactive shells.
    struct Init: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Output the shell integration function so it can be sourced."
        )

        /// The target shell that should receive the helper function definition.
        @Argument(help: "The shell that should be initialized. Supported values: \(Shell.supportedValues)")
        var shell: Shell

        func run() throws {
            print(shell.script)
        }
    }
}

extension Xcodecd.Init {
    /// Shells that can be initialized by `xcodecd init`.
    enum Shell: String, ExpressibleByArgument, CaseIterable {
        case fish, bash

        static var supportedValues: String {
            allCases.map(\.rawValue).joined(separator: ", ")
        }

        /// Returns the shell function implementations as packaged scripts.
        fileprivate var script: String {
            switch self {
            case .fish: FishInitScript.contents
            case .bash: BashInitScript.contents
            }
        }
    }
}
