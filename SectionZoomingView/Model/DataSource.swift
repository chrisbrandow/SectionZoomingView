//
//  DataSource.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 2/2/21.
//

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

struct TakeoutDataSource {

    //this is temporary. next up, start using the menugroup directly
//    let entries: [Entry]
    enum Example: String, CaseIterable {
        case zingari_4_29 = "zingari4Section29"
        case paradiso_23_304 = "Paradiso23Section304"
        case laPressa_4_14 = "laPressa4Section14"
        case mint_11_123 = "54Mint11Section123"
        case coquetta_11_31 = "coqueta11Section31"
        case betterZoom = "better zoom"

        var displayName: String {
            switch self {
            case .zingari_4_29: return "Zingari"// (4 sections 29 items)"
            case .paradiso_23_304: return "Paradiso"// (23 sections 304 items)"
            case .laPressa_4_14: return "La Pressa"// (4 sections 14 items)"
            case .mint_11_123: return "Mint 54"// (11 sections 123 items)"
            case .coquetta_11_31: return "Coquetta"// (11 sections 31 items)"
            case .betterZoom: return "better zoom"
            }
        }
    }

    var entireMenu: MenuGroup

    static func load(example: Example, title: String) throws -> MenuGroup {
        let data = try Loader().loadData(named: example.rawValue)
        var result = try JSONDecoder().decode(MenuGroup.self, from: data)
        result.title = title
        return result
    }

    init(example: Example) throws {
        self.entireMenu = try Self.load(example: example, title: example.displayName)
    }
}
