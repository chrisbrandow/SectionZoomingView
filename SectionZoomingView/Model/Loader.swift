import Foundation

class Loader {
    enum LoaderError: Error {
        case standard(String)
    }

    static let shared = Loader()

    func loadData(named: String) throws -> Data {
        guard let path = Bundle.main.path(forResource: named, ofType: "json")
        else { throw LoaderError.standard("could not create path for \(named)") }
        return try Data(contentsOf: URL(fileURLWithPath: path, isDirectory: false))
    }

    func loadString(named: String) throws -> String {
        guard let path = Bundle.main.path(forResource: named, ofType: "json")
        else { throw LoaderError.standard("could not create path for \(named)") }
        return self.cleanRows(try String(contentsOfFile: path, encoding: .utf8))
    }

    func cleanRows(_ contents: String) -> String {
        var contents = contents
        contents = contents.replacingOccurrences(of: "\r", with: "\n")
        contents = contents.replacingOccurrences(of: "\n\n", with: "\n")
        return contents
    }
}
