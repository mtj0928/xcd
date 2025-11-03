import ArgumentParser
import Foundation
import Noora

@main
struct Xcodecd: ParsableCommand {
    static let configuration: CommandConfiguration = CommandConfiguration(
        commandName: "xcodecd",
        subcommands: [Init.self]
    )

    func run() throws {
        do {
            let projects = try RecentProjectsLoader().load()
            let selectedProject = Noora().singleChoicePrompt(
                question: "Select project you want to open",
                options: projects,
                filterMode: .enabled
            )
            print(selectedProject.destinationPath.path(percentEncoded: false))
        } catch let error as RecentProjectsError {
            throw error
        } catch {
            throw CLIError("Unexpected error: \(error.localizedDescription)")
        }
    }
}
