//
//  Diner.swift
//  SectionZoomingView
//
//  Created by Doug Boutwell on 11/2/22.
//

import Foundation

struct Diner: Codable, Equatable, Identifiable {
    var id: UUID = UUID()

    var firstName: String

    var lastName: String

    var initials: String {
        return PersonNameComponents(givenName: firstName, familyName: lastName)
            .formatted(.name(style: .abbreviated))
    }
}

extension Diner: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension Diner {
    static let chris = Diner(firstName: "Chris", lastName: "Brandow")
    static let doug = Diner(firstName: "Doug", lastName: "Boutwell")
    static let erika = Diner(firstName: "Erika", lastName: "McLepke")
    static let ryosuke = Diner(firstName: "Ryosuke", lastName: "Onaka")
    static let taylor = Diner(firstName: "Taylor", lastName: "Dodds")

    static let allCases: [Diner] = [chris, doug, erika, ryosuke, taylor]
}
