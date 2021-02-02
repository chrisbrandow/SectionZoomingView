//
//  DataSource.swift
//  SectionZoomingView
//
//  Created by Chris Brandow on 2/2/21.
//

import Foundation

class Loader {
    static let shared = Loader()
    func loadString(named: String) throws -> String {
        print(named)
        return try String(contentsOfFile: Bundle.main.path(forResource: named, ofType: "json") as! String, encoding: .utf8)
    }
//    func loadJsonNamed(_ named : String, bundle payloadBundlePath: String? = nil) -> [String:AnyObject]? {
//        let resolvedBundle: Bundle?
//        if let bundlePath = payloadBundlePath {
//            resolvedBundle = Bundle(path: bundlePath)
//        } else {
//            resolvedBundle = Bundle.main
//        }
//
//        guard let path = resolvedBundle?.path(forResource: named, ofType: "json"),
//              let data = try? Data(contentsOfFile: path), encoding: ) else {
//            NSLog("could not load json named \(named)")
//            return nil
//        }
//        return (try? JSONSerialization.jsonObject(with: data, options:[])) as? [String:AnyObject]
//    }
//
//    func loadDataNamed(_ fileName: String, fileType: String) -> String? {
//        guard let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: fileType) else {
//            return nil
//        }
//
//        do {
//            var contents = try String(contentsOfFile: path, encoding: .utf8)
//            contents = cleanRows(contents)
//            return contents
//        } catch {
//            return nil
//        }
//    }
//
//    func cleanRows(_ contents: String) -> String {
//        var contents = contents
//        contents = contents.replacingOccurrences(of: "\r", with: "\n")
//        contents = contents.replacingOccurrences(of: "\n\n", with: "\n")
//        return contents
//    }
}
//TODO: Chris Brandow  2021-02-02 to find a good example of menus, add this `HomeRestaurantCarouselCell
public enum Currency: Equatable {

    case CAD, GBP, MXN, USD, EUR, JPY, AUD, AED, unknown

    public static func fromString(_ type: String?) -> Currency {
        guard let type = type else { return .unknown }

        switch type.uppercased() {
        case "CAD":
            return .CAD
        case "GBP":
            return .GBP
        case "MXN":
            return .MXN
        case "USD":
            return .USD
        case "EUR":
            return .EUR
        case "JPY":
            return .JPY
        case "AUD":
            return .AUD
        case "AED":
            return .AED
        default:
            return .unknown
        }
    }

    public var stringValue: String {
        switch self {
        case .CAD:
            return "CAD"
        case .GBP:
            return "GBP"
        case .MXN:
            return "MXN"
        case .USD:
            return "USD"
        case .EUR:
            return "EUR"
        case .JPY:
            return "JPY"
        case .AUD:
            return "AUD"
        case .AED:
            return "AED"
        default:
            return "USD"
        }
    }
}


public struct Price: CustomDebugStringConvertible, Hashable {
    public let amount: Decimal
    public let currency: Currency?

    public init(amountTimes100: Decimal, currency: Currency?) {
        self.amount = amountTimes100 / 100
        self.currency = currency
    }

    public init(exactAmount: Decimal, currency: Currency?) {
        self.amount = exactAmount
        self.currency = currency
    }

    public static func *(lhs: Price, rhs: Decimal) -> Price {
        return Price(exactAmount: lhs.amount * rhs, currency: lhs.currency)
    }

    public var debugDescription: String {
        return "amount: \(self.amount),\ncurrency: \(self.currency?.stringValue ?? "-")"
    }

    public var formattedDescription: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = self.currency?.stringValue

        return formatter.string(from: NSDecimalNumber(decimal: self.amount))
    }
}

public struct TakeoutMenuGroup: Equatable, CustomDebugStringConvertible {
    private let menus: [TakeoutMenu]

    public init(menus: [TakeoutMenu]) {
        self.menus = menus
    }

    public var debugDescription: String {
        return "menus: \(self.menus)"
    }

    public var allSections: [TakeoutMenuSection] {
        self.menus.flatMap { $0.sections }
    }

    public var allItems: [TakeoutMenuItem] {
        self.menus.flatMap { $0.items }
    }

    public func contains(_ item: TakeoutMenuItem) -> Bool {
        return self.allItems.contains(item)
    }

    public func isPreviewOf(_ other: TakeoutMenuGroup) -> Bool {
        return Set(self.allItems).isSubset(of: other.allItems)
    }

    public func setItemsSoldOut(for ids: [String]) {
        ids.forEach { id in
            guard let item = self.allItems.first(where: { $0.id == id }) else {
                return
            }
            item.setSoldOut(true)
        }
    }
}

// MARK: - TakeoutMenu

public struct TakeoutMenu: Equatable, CustomDebugStringConvertible {
    public let name: String
    public let menuDescription: String?
    public let items: [TakeoutMenuItem]
    public let sections: [TakeoutMenuSection]

    init(name: String, menuDescription: String?, sections: [TakeoutMenuSection]) {
        self.name = name
        self.menuDescription = menuDescription
        self.sections = sections
        self.items = sections.flatMap { $0.items }
    }

    public func contains(_ item: TakeoutMenuItem) -> Bool {
        return self.items.contains(item)
    }

    public var debugDescription: String {
        return "name: \(self.name); items: \(self.items)"
    }

    public static func ==(lhs: TakeoutMenu, rhs: TakeoutMenu) -> Bool {
        return lhs.name == rhs.name && lhs.items == rhs.items
    }
}

// MARK: - TakeoutMenuSection

public struct TakeoutMenuSection {
    public let name: String?
    public let sectionDescription: String?
    public let items: [TakeoutMenuItem]
}

// MARK: - TakeoutMenuItem

public class TakeoutMenuItem: Equatable, Hashable {

    public let id: String
    public let name: String
    public let itemDescription: String?
    public private(set) var isSoldOut: Bool
    public let attributes: [String]
    public let modifierGroups: [TakeoutModifierGroup]
    public let price: Price

    init(id: String, name: String, itemDescription: String?, isSoldOut: Bool, attributes: [String], modifierGroups: [TakeoutModifierGroup], price: Price) {
        self.id = id
        self.name = name
        self.itemDescription = itemDescription
        self.isSoldOut = isSoldOut
        self.attributes = attributes
        self.modifierGroups = modifierGroups
        self.price = price
    }

    public func setSoldOut(_ value: Bool) {
        self.isSoldOut = value
    }

    public static func ==(lhs: TakeoutMenuItem, rhs: TakeoutMenuItem) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

// MARK: - TakeoutModifierGroup

public struct TakeoutModifierGroup: Equatable, Hashable {
    public let id: String
    public let name: String
    public let description: String?
    public let required: Bool
    public let allowsMultipleSelection: Bool
    public let minimumAllowed: Int?
    public let maximumAllowed: Int?
    public let modifiers: [TakeoutModifier]

    public static func ==(lhs: TakeoutModifierGroup, rhs: TakeoutModifierGroup) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - TakeoutModifier

public struct TakeoutModifier: Equatable, Hashable {
    public let id: String
    public let name: String
    public let description: String?
    public let price: Price?
    public let tax: Price?

    public static func ==(lhs: TakeoutModifier, rhs: TakeoutModifier) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Obj-C Interop

@objc
public final class TakeoutMenusObjCBox: NSObject {
    let menus: TakeoutMenuGroup

    public init(menus: TakeoutMenuGroup) {
        self.menus = menus
    }
}

// MARK: - TakeoutMenuAssembler

@objc
public final class TakeoutMenuAssembler: NSObject {

    @objc(sharedInstance)
    public static let shared = TakeoutMenuAssembler()

    @objc
    public func createMenusBox(_ dtos: NSArray) -> TakeoutMenusObjCBox {
        let menus = dtos.compactMap { rawMenuDto -> TakeoutMenu? in
            guard let menuDto = rawMenuDto as? [String:Any] else {
                return nil
            }
            return self.createMenu(from: menuDto)
        }
        let menuGroup = TakeoutMenuGroup(menus: menus)
        return TakeoutMenusObjCBox(menus: menuGroup)
    }

    public func createMenus(from dto: [String:Any]) -> TakeoutMenuGroup {
        guard let menuDtos = dto["menus"] as? [[String:Any]] else {
            return TakeoutMenuGroup(menus: [])
        }

        let menus = menuDtos.compactMap { self.createMenu(from: $0) }
        return TakeoutMenuGroup(menus: menus)
    }

    private func createMenu(from dto: [String:Any]) -> TakeoutMenu? {
        let description = dto["description"] as? String
        guard let name = dto["name"] as? String,
              let sectionDtos = dto["groups"] as? [[String:Any]] else {
            return nil
        }

        let sections = sectionDtos.compactMap { self.createSection(from: $0) }
        assert(sections.isEmpty == false, "as per spec, can't create a menu with no items")
        return TakeoutMenu(name: name, menuDescription: description, sections: sections)
    }

    private func createSection(from dto: [String:Any]) -> TakeoutMenuSection? {
        let name = dto["name"] as? String
        let description = dto["description"] as? String

        guard let itemDtos = dto["items"] as? [[String:Any]] else {
            return nil
        }
        let items = itemDtos.compactMap { self.createItem(from: $0) }
        guard items.isEmpty == false else {
            return nil
        }

        return TakeoutMenuSection(name: name, sectionDescription: description, items: items)
    }

    private func createItem(from dto: [String:Any]) -> TakeoutMenuItem? {
        guard let id = dto["id"] as? String,
              let name = dto["name"] as? String,
              let price = dto["price"] as? [String:Any],
              let amount = price["amount"] as? Int,
              let currencyString = price["currency"] as? String else {
            return nil
        }

        let currency = Currency.fromString(currencyString)

        let description = dto["description"] as? String
        let attributes = dto["attributes"] as? [String] ?? []
        let isSoldOut = dto["isSoldOut"] as? Bool ?? false

        let modifierGroupDtos = dto["modifierGroups"] as? [[String:Any]] ?? []
        let modifierGroups = modifierGroupDtos.compactMap { self.createModifierGroup(from: $0) }

        let itemPrice = Price(amountTimes100: Decimal(amount), currency: currency)
        return TakeoutMenuItem(id: id, name: name, itemDescription: description, isSoldOut: isSoldOut, attributes: attributes, modifierGroups: modifierGroups, price: itemPrice)
    }

    private func createModifierGroup(from dto: [String:Any]) -> TakeoutModifierGroup? {
        guard let id = dto["id"] as? String,
              let name = dto["name"] as? String,
              let modifierDtos = dto["modifiers"] as? [[String:Any]] else {
            return nil
        }

        let description = dto["description"] as? String
        let required = dto["required"] as? Bool ?? false
        let allowsMultipleSelection = dto["multipleSelection"] as? Bool ?? false
        let minimumRequired = dto["minChoices"] as? Int
        let maximumRequired = dto["maxChoices"] as? Int

        let modifiers = modifierDtos.compactMap { self.createModifier(from: $0) }

        // no empty modifier groups
        guard modifiers.isEmpty == false else {
            return nil
        }

        return TakeoutModifierGroup(id: id, name: name, description: description, required: required, allowsMultipleSelection: allowsMultipleSelection, minimumAllowed: minimumRequired, maximumAllowed: maximumRequired, modifiers: modifiers)
    }

    private func createModifier(from dto: [String:Any]) -> TakeoutModifier? {
        guard let id = dto["id"] as? String,
              let name = dto["name"] as? String else {
            return nil
        }
        let description = dto["description"] as? String

        var price: Price?
        if let priceDto = dto["price"] as? [String:Any],
           let priceAmount = priceDto["amount"] as? Int,
           let priceCurrencyString = priceDto["currency"] as? String {
            let priceCurrency = Currency.fromString(priceCurrencyString)
            price = Price(amountTimes100: Decimal(priceAmount), currency: priceCurrency)
        }

        var tax: Price?
        if let taxDto = dto["tax"] as? [String:Any],
           let taxAmount = taxDto["amount"] as? Int,
           let taxCurrencyString = taxDto["currency"] as? String {
            let taxCurrency = Currency.fromString(taxCurrencyString)
            tax = Price(amountTimes100: Decimal(taxAmount), currency: taxCurrency)
        }

        return TakeoutModifier(id: id, name: name, description: description, price: price, tax: tax)
    }
}

class TakeoutDataSource {

    enum Example: String, CaseIterable {
        case zingari_4_29 = "zingari4Section29"
        case paradiso_23_304 = "Paradiso23Section304"
        case laPressa_4_14 = "laPressa4Section14"
        case mint_11_123 = "54Mint11Section123"
        case coquetta_11_31 = "coqueta11Section31"
    }
    let entireMenu: TakeoutMenuGroup

    convenience init(example: Example) {
        let string = try! Loader.shared.loadString(named: example.rawValue)
        self.init(string: string)
    }

    init(string: String) {
        guard let menuDtoString = string.data(using: .utf8),
              let dto = try? JSONSerialization.jsonObject(with: menuDtoString, options: .allowFragments),
        let menuDto = dto as? [String: Any]
        else { self.entireMenu = TakeoutMenuGroup(menus: []); return}
        self.entireMenu = TakeoutMenuAssembler.shared.createMenus(from: menuDto)
        
    }
}

struct Entry {
    let title: String
    let description: String
    let price: String
}

class DataSource {
    let entries: [Entry]

    convenience init() {
        self.init(string: stringSource)
    }


    init(string: String) {
        let lines = string.components(separatedBy: .newlines)
        self.entries = lines.map {
            let firstSplit = $0.components(separatedBy: "---")
            let title = firstSplit.first?.trimmingCharacters(in: .whitespaces) ?? ""
            let descriptAndPrice = firstSplit.last?.components(separatedBy: "--")
            let description = descriptAndPrice?.first?.trimmingCharacters(in: .whitespaces) ?? ""

            let price = descriptAndPrice?.count == 2 ? descriptAndPrice?.last?.trimmingCharacters(in: .whitespaces) ?? "n/a" : "n/a"
            return Entry(title: title, description: description, price: price)

        }
    }
}

//let shortSource =

let stringSource = """
Vegetarian Crispy Roll --- Silver noodles, dried mushrooms, cabbage and carrots served with sweet & sour plum dipping -- n/a Osha Fresh Spring Rolls --- Shrimp, lettuce, mint wrapped in fresh rice paper and homemade peanut dipping -- n/a Frog Legs --- Crispy frog leg tossed with Gilroy garlic, sea salt and black pepper -- n/a Duck Rolls --- Roasted duck rolled with cucumber, green onion, cilantro, carrotand tortilla served with cinnamon hoisin dipping -- n/a Thai Samosa --- Potato, carrot, curry and onion in a pot sticker wrapper served with fresh cucumber salad -- n/a Herbal Chicken Wings --- Deep-fried chicken wings tossed with spice herb truffle salt served with our homemade sauce -- n/a Lamb & Chicken Satay --- Marinated chicken and lamb with Thai curry powder served with peanut sauce and fresh cucumber salad -- n/a Beef Wasabi Rolls --- Carrot, celery and mint wrapped in sliced grilled premium flank steak served with watercress salad -- n/a Dungeness Crab Rangoon --- Crispy wonton filled with Dungeness crab meat, cream cheese water chestnuts, onion, carrot served with plum dipping -- n/a Firecracker Prawns --- Southeast Asian-Style Grilled Prawns with Aromatic Herbs served with spicy lime vinaigrette -- n/a Ahi Tuna Wasabi --- Pan-seared sesame crusted Ahi Tuna served with crispy red onion and a secret recipe balsamic coulis -- n/a Tuna Tower --- Yellow Fin Tuna tartare with cilantro, mango, avocado, toasted garlic and Sriracha-sesame sauce served with fried wonton -- n/a Salmon Rolls --- Salmon marinated with Thai spices, basil leaves, tobiko caviar, Avocado wrapped in a spring roll skin served with cilantro aioli -- n/a Bacon Wrapped Scallop --- Tender sea scallop lightly wrapped in smoky bacon served with three flavors cream sauce -- n/a Crunchy Tofu --- Organic Japanese tofu served with green apple and Sriracha cream -- n/a Market Fruit Salad --- Fruit combinations tossed with tamarind sweet & sour vinaigrette -- n/a Sorbet Siam Salad --- Famous Siam marinated shrimp and English Cucumber, radish topped with cilantro sorbet -- n/a Papaya Salad --- Grilled prawns, shredded green papaya seasoned, tomato and peanuts served with tamarind lime dressing -- n/a Mango Salad --- Steamed prawns, sliced mango, red onions, mint, cilantro, Kaffir lime leaf and cashew nuts in spicy lemongrass dressing -- n/a Salmon Sashimi Salad --- Fresh mango, lemongrass, Kaffir lime leaf, red onion, cucumber, green onion, cilantro and sesame oil with spicy lime dressing -- n/a Kobe Beef Salad --- \"Snake River Farms\" Kobe beef grilled to perfection served with Thai eggplant, lemongrass, tomatoes, chili, radish, frisse and lime dressing -- n/a Chieng-Mai Lettuce Wrap --- Famous northern-style chicken larb lettuce tossed with aromatic herb and onion served with Artisan romaine -- n/a Cup/Bowl --- Choice of Vegetarian or chicken Choice of calamari, mussels, or prawns Seafood Combination -- n/a Tom Yum --- Hot & Sour soup with lemongrass, galangal, mushrooms, and tomatoes -- n/a Tom Kha --- Traditional coconut soup with lemongrass, galangal, Kaffir lime leaf and mushroom -- n/a Tom Zap Beef --- Famous Northeast hot sour soup with lemongrass, galangal, Kaffir lime leaf, Thai basil, cilantro, and white mushroom -- n/a Kobe Beef --- \"Snake River Farms\" Kobe beef grilled to perfection served with black pepper shiitake mushroom -- n/a Herbal Kobe Pad-Cha --- Wok-fried \"snake river farms\" flats irons Kobe steak galangal, lemongrass, kaffir lime, bell pepper, red curry jam and Thai basil -- n/a Volcanic Beef --- Wok-fried grilled premium USDA certified flank steak with basil, bell pepper and black pepper in Lava sauce garnished with onion rings -- n/a Garlic Lamb Ribs --- Deep-fried marinated rack of Australian lamb served with summer salad -- n/a Kana Moo-Krob --- Wok-fried Chinese broccoli with crispy pork belly, chili and garlic sauce Kana - Chinese broccoli, Moo-Krob - crispy pork belly -- n/a Kurobuta Pork Belly --- Slow braised famous Kurobuta (Black Hog) served with secret five-spice reduction and flower sticky rice -- n/a Country Chicken --- Stir-fried lightly battered chicken with cashew, onion, garlic, red bell pepper and homemade honey-ginger sauce -- n/a Lemongrass Chicken --- Stir-fried chicken, coconut milk, lemongrass, green onion and chili -- n/a Ka-Prow-Kai (Thai comfort food) --- Wok-fried minced chicken, Thai basil, fresh chili, red bell pepper and brown garlic sauce -- n/a Honey Duck --- Roasted duck in honey glaze served over steamed bok choy with spicy black soy dipping sauce -- n/a Tom Yum Seafood --- Wok-fried assorted fresh seafood, lemongrass, galangal, mushroom, tomato and hot & sour reduction served on sizzling plate -- n/a Angry Prawn --- Sautéed River prawns with curry paste and Kaffir lime leaf served over fried eggplant on a hot plate -- n/a Totally Scallop --- Curry peanut puree, and roasted sweet cashew nut butter; served with zucchini & carrot -- n/a Crisp Salmon --- Crispy salmon topped with caramelized onion, mango, and pineapple red bell pepper, yam and crispy Thai basil -- n/a Osha\'s Sea --- Prawns, salmon, scallops calamari, mussels and crab claws with a thick spicy curry sauce and light coconut milk over roasted eggplant -- n/a Lemongrass Sea Bass --- Steamed marinated sea bass with lemongrass, kaffir lime leaf topped with fried lemongrass served in a clay pot -- n/a Grilled Sea Bass --- Glazed with sweet hot mustard, served with warm baby bok choy and cilantro aioli -- n/a Heavenly Sea Bass --- Steamed fillet Chilean sea bass, lemongrass, basil, mushroom and spring cabbage topped with Asian style spicy garlic lime dressing -- n/a Panang Curry --- Cube of premium USDA certified flank beef with bell pepper and basil leaf in Panang curry -- n/a Green Curry --- With bamboo shoots and choice of chicken or beef -- n/a Yellow Curry --- With bell pepper, onion, potato and choice of chicken, beef or pork -- n/a Duck Curry --- Sliced roasted duck with pineapple, grapes and tomatoes in red curry -- n/a Pumpkin Curry --- Kabocha pumpkin in red curry sauce choice of chicken, beef or pork topped with crispy yam -- n/a Hung-Lay Curry --- A fragrant and flavorful curry of Northwest Thailand with slow-braised cubes of Canadian pork, ginger, garlic and served with roti -- n/a Mussamun Lamb --- Slow-braised lamb shank, peanuts, Kabocha squash served with cucumber radish and two-toned rice -- n/a Prawns Pineapple --- River prawns with lychee, pineapple, red bell pepper in red curry sauce -- n/a Pad Thai --- Chicken, prawns or crab stir-fried with egg, bean sprouts, chives, tofu and ground peanuts. Choice of rice noodle, silver noodle or fried wonton -- n/a Pad See You --- Rice noodle pan-fried with Chinese broccoli, egg, black soy bean sauce and choice of chicken, beef or pork -- n/a Thai Spicy Pan Fried --- Rice noodle stir-fried with tomato, mushroom, bamboo shoots, Chinese broccoli, bell pepper, onion, basil, chili and choice of chicken, beef or pork -- n/a Crab Fried Rice --- Fried rice with egg, onion and green onion with fresh crab meat served with fresh cucumber -- n/a Pineapple Fried Rice --- Fried rice with egg, tomato, onion, green onion, cashew nuts, raisins, pineapple, chicken and prawns -- n/a Clay Pot --- Wok-fried, fresh tofu (lightly battered), shitake mushroom, green onion, celery, ginger and boy choy served in Japanese clay pot -- n/a Asparagus with Tofu (side order) --- Sautéed asparagus and tofu with garlic sauce -- n/a Sautéed Mushroom (side order) --- Stir-fried shiitake mushroom with green peppercorn -- n/a Spicy Eggplant (side order) --- Stir-fried eggplant, tofu, basil and red bell pepper -- n/a Spicy String Bean (side order) --- Stir-fried string bean with curry paste sauce -- n/a Vegetarian Crispy Roll --- Silver noodles, dried mushrooms, cabbage and carrots served with sweet & sour plum dipping -- n/a Osha Fresh Spring Rolls --- Shrimp, lettuce, mint wrapped in fresh rice paper and homemade peanut dipping -- n/a Frog Legs --- Crispy frog leg tossed with Gilroy garlic, sea salt and black pepper -- n/a Duck Rolls --- Roasted duck rolled with cucumber, green onion, cilantro, carrotand tortilla served with cinnamon hoisin dipping -- n/a Thai Samosa --- Potato, carrot, curry and onion in a pot sticker wrapper served with fresh cucumber salad -- n/a Herbal Chicken Wings --- Deep-fried chicken wings tossed with spice herb truffle salt served with our homemade sauce -- n/a Lamb & Chicken Satay --- Marinated chicken and lamb with Thai curry powder served with peanut sauce and fresh cucumber salad -- n/a Beef Wasabi Rolls --- Carrot, celery and mint wrapped in sliced grilled premium flank steak served with watercress salad -- n/a Dungeness Crab Rangoon --- Crispy wonton filled with Dungeness crab meat, cream cheese water chestnuts, onion, carrot served with plum dipping -- n/a Firecracker Prawns --- Southeast Asian-Style Grilled Prawns with Aromatic Herbs served with spicy lime vinaigrette -- n/a Ahi Tuna Wasabi --- Pan-seared sesame crusted Ahi Tuna served with crispy red onion and a secret recipe balsamic coulis -- n/a Tuna Tower --- Yellow Fin Tuna tartare with cilantro, mango, avocado, toasted garlic and Sriracha-sesame sauce served with fried wonton -- n/a Salmon Rolls --- Salmon marinated with Thai spices, basil leaves, tobiko caviar, Avocado wrapped in a spring roll skin served with cilantro aioli -- n/a Bacon Wrapped Scallop --- Tender sea scallop lightly wrapped in smoky bacon served with three flavors cream sauce -- n/a Crunchy Tofu --- Organic Japanese tofu served with green apple and Sriracha cream -- n/a Market Fruit Salad --- Fruit combinations tossed with tamarind sweet & sour vinaigrette -- n/a Sorbet Siam Salad --- Famous Siam marinated shrimp and English Cucumber, radish topped with cilantro sorbet -- n/a Papaya Salad --- Grilled prawns, shredded green papaya seasoned, tomato and peanuts served with tamarind lime dressing -- n/a Mango Salad --- Steamed prawns, sliced mango, red onions, mint, cilantro, Kaffir lime leaf and cashew nuts in spicy lemongrass dressing -- n/a Salmon Sashimi Salad --- Fresh mango, lemongrass, Kaffir lime leaf, red onion, cucumber, green onion, cilantro and sesame oil with spicy lime dressing -- n/a Kobe Beef Salad --- \"Snake River Farms\" Kobe beef grilled to perfection served with Thai eggplant, lemongrass, tomatoes, chili, radish, frisse and lime dressing -- n/a Chieng-Mai Lettuce Wrap --- Famous northern-style chicken larb lettuce tossed with aromatic herb and onion served with Artisan romaine -- n/a Cup/Bowl --- Choice of Vegetarian or chicken; Choice of calamari, mussels, or prawns; Seafood Combination -- n/a Tom Yum --- Hot & Sour soup with lemongrass, galangal, mushrooms, and tomatoes -- n/a Tom Kha --- Traditional coconut soup with lemongrass, galangal, Kaffir lime leaf and mushroom -- n/a Tom Zap Beef --- Famous Northeast hot sour soup with lemongrass, galangal, Kaffir lime leaf, Thai basil, cilantro, and white mushroom -- n/a Kobe Beef --- \"Snake River Farms\" Kobe beef grilled to perfection served with black pepper shiitake mushroom -- n/a Volcanic Beef --- Wok-fried grilled premium USDA certified flank steak with basil, bell pepper and black pepper in Lava sauce garnished with onion rings -- n/a Herbal Kobe Pad-Cha --- Wok-fried \"snake river farms\" flats irons Kobe steak galangal, lemongrass, kaffir lime, bell pepper, red curry jam and Thai basil -- n/a Garlic Lamb Ribs --- Deep-fried marinated rack of Australian lamb served with summer salad -- n/a Taro Rice & Kurobuta Pork Belly --- Slow-braised famous Kurobuta (Black Hog) served with secret five-spice reduction and Taro rice -- n/a Kana Moo-Krob --- Wok-fried Chinese broccoli with crispy pork belly, chili and garlic sauce Kana - Chinese broccoli, Moo-Krob - crispy pork belly -- n/a Country Chicken --- Stir-fried lightly battered chicken with cashew, onion, garlic, red bell pepper and homemade honey-ginger sauce -- n/a Lemongrass Chicken --- Stir-fried chicken, coconut milk, lemongrass, green onion and chili -- n/a Ka-Prow-Kai (Thai comfort food) --- Wok-fried minced chicken, Thai basil, fresh chili, red bell pepper and brown garlic sauce -- n/a Spicy Eggplant --- Stir-fried eggplant, basil, fresh chili, red bell pepper and choice of sliced chicken, beef, or pork -- n/a Honey Duck --- Roasted duck in honey glaze served over steamed bok choy with spicy black soy dipping sauce -- n/a Sizzling Tom Yum Seafood --- Wok-fried assorted fresh seafood, lemongrass, galangal, mushroom, tomato and hot & sour reduction served on sizzling plate -- n/a Angry Prawn --- Sautéed River prawns with curry paste and Kaffir lime leaf served over fried eggplant on a hot plate -- n/a Totally Scallop --- Curry peanut puree, and roasted sweet cashew nut butter; served with zucchini & carrot -- n/a Crisp Salmon --- Crispy salmon topped with caramelized onion, mango, and pineapple red bell pepper, yam and crispy Thai basil -- n/a Osha\'s Sea --- Prawns, salmon, scallops calamari, mussels and crab claws with a thick spicy curry sauce and light coconut milk over roasted eggplant -- n/a Lemongrass Sea Bass --- Steamed marinated sea bass with lemongrass, kaffir lime leaf topped with fried lemongrass served in a clay pot -- n/a Grilled Sea Bass --- Glazed with sweet hot mustard, served with steamed baby bok choy and homemade spicy tangy sauce -- n/a Heavenly Sea Bass --- Steamed fillet Chilean sea bass, lemongrass, basil, mushroom and spring cabbage topped with Asian style spicy garlic lime dressing -- n/a Panang Curry --- Cube of premium USDA certified flank beef with bell pepper and basil leaf in Panang curry -- n/a Green Curry --- With bamboo shoots and choice of chicken or beef -- n/a Yellow Curry --- With bell pepper, onion, potato and choice of chicken, beef or pork -- n/a Duck Curry --- Sliced roasted duck with pineapple, grapes and tomatoes in red curry -- n/a Pumpkin Curry --- Kabocha pumpkin in red curry sauce choice of chicken, beef or pork topped with crispy yam -- n/a Hung-Lay Curry --- A fragrant and flavorful curry of Northwest Thailand with slow-braised cubes of Canadian pork, ginger, garlic and served with roti -- n/a Prawns Pineapple --- River prawns with lychee, pineapple, red bell pepper in red curry sauce -- n/a Thai Fried Rice --- Fried rice with egg, tomatoes, onion and green onion with the choice of chicken, beef or pork -- n/a Crab Fried Rice --- Fried rice with egg, onion and green onion with fresh crab meat served with fresh cucumber -- n/a Pineapple Fried Rice --- Fried rice with egg, tomato, onion, green onion, cashew nuts, raisins, pineapple, chicken and prawns -- n/a Pad Thai --- Chicken, prawns or crab stir-fried with egg, bean sprouts, chives, tofu and ground peanuts. Choice of rice noodle, silver noodle or fried wonton -- n/a Pad See You --- Rice noodle pan-fried with Chinese broccoli, egg, black soy bean sauce and choice of chicken, beef or pork -- n/a Thai Spicy Pan Fried --- Rice noodle stir-fried with tomato, mushroom, bamboo shoots, Chinese broccoli, bell pepper, onion, basil, chili and choice of chicken, beef or pork -- n/a Osha Udon Tom Yum Koong --- Udon noodles, prawn, mushroom served with hot & sour tom yum soup -- n/a Vegetable Noodle Soup --- Fresh tofu, spinach, broccoli, bean sprouts in classic clear broth and Choice of egg noodles or rice noodles -- n/a Clay Pot --- Wok-fried, fresh tofu (lightly battered), shitake mushroom, green onion, celery, ginger and boy choy served in Japanese clay pot -- n/a Asparagus with Tofu --- Sautéed asparagus and tofu with garlic sauce -- n/a Spicy String Bean --- Stir-fried string bean with chili paste sauce -- n/a Praram --- Steamed assorted vegetables and tofu with peanut sauce -- n/a Osha Vanilla Ball (fried ice cream) --- Vanilla ice cream served in a warm blanket of tempura-style fried bread and fresh berries -- n/a Fried Banana with Ice Cream --- Crispy banana summer rolls served with choice of vanilla or coconut ice cream -- n/a Chocolate Soufflé & Thai Tea Ice cream --- Warm chocolate cake with a heart of creamy \"A\" grade chocolate served with homemade Thai tea ice cream -- n/a Coconut Sorbet --- Sweet smooth coconut sorbet made with coconut milk from Thailand and a hint of coconut water -- n/a Bangkok Cotta & Black Sticky Rice --- Thai style silky panna cotta served with coconut black sticky rice -- n/a Key Lime Cheesecake --- New York style cheesecake with a splash of key limejuice, decorated with lime marmalade -- n/a Mango Sticky Rice (Seasonal) --- Sweet sticky rice served with mango topped with coconut cream -- n/a Espresso Crème Brulee (Seasonal) --- Rich custard flavored with Espresso infused served cooled with a hot crispy caramelized sugar -- n/a Espresso ---  -- n/a Americano ---  -- n/a Cappuccino ---  -- n/a Caffé Latte ---  -- n/a Karlsson\'s Chocolate Martini ---  -- n/a Yalumba Antique Tawny / Australia ---  -- n/a CLA Special Reserve Porto / Portugal ---  -- n/a Moscato d\'Asti/ La Spinetta --- Vigneto Biancospino/ Italy/ 2007 -- n/a Dr. Loosen / Ürziger Würzgarten --- Auslese/ Saar / 2002 (375ml) -- n/a Andreas Schmitges / Auslese --- Middle Mosel / 2007 (500ml) -- n/a Hennessy VS ---  -- n/a Remy Martin, VSOP ---  -- n/a Martell, VSOP ---  -- n/a Martell, \"Gordon Blu\" ---  -- n/a Macallan Flight --- Macallan 12,15, and 18 year -- n/a Glenlivet Flight --- Glenlivet 12,15, and 16 year -- n/a Islay Flight --- Bowmore 12, Lagavulin 16, and Laphroaig -- n/a Osha Selection Flight --- Oban 14, Yamazaki 12, and Spring Bank 10 -- n/a Grand Flight --- Hudson, Yamazaki 18, and Old Potrero SF -- n/a Laphroig, 10 year, Single Islay ---  -- n/a Lagavulin, 16 year, Single Islay ---  -- n/a Old Potrero, 18th Century style San Francisco ---  -- n/a Hudson, New York ---  -- n/a Johnny Walker \"Blue Label\" ---  -- n/a Suntory \"Yamazaki\" --- 12 year, Japan -- n/a Suntory \"Yamazaki\" --- 18 year, Japan -- n/a
"""

let st = "{\n  \"summaryAvailability\" : {\n    \"firstAvailableTimeslot\" : {\n      \"points\" : 0,\n      \"priceAmount\" : 0,\n      \"dateTime\" : \"2021-02-02T11:45\",\n      \"slotHash\" : \"903275056\",\n      \"available\" : true,\n      \"token\" : \"eyJ2IjoyLCJtIjowLCJwIjowLCJjIjo2LCJzIjowLCJuIjoxfQ\"\n    },\n    \"hasOtherTimes\" : true,\n    \"firstAvailableLeadTime\" : 15\n  },\n  \"menus\" : [\n    {\n      \"name\" : \"Chouquet\'s\",\n      \"groups\" : [\n        {\n          \"name\" : \"Special Menu\",\n          \"items\" : [\n            {\n              \"id\" : \"69fb64c1-5686-46e3-9f72-7f87bcc25949\",\n              \"price\" : {\n                \"amount\" : 1500,\n                \"currency\" : \"USD\"\n              },\n              \"isSoldOut\" : true,\n              \"description\" : \"w\\/ Canadian Bacon\",\n              \"modifierGroups\" : [\n\n              ],\n              \"name\" : \"Egg Benedict\",\n              \"attributes\" : [\n                \"Served until 4pm\"\n              ]\n            },\n            {\n              \"id\" : \"8a97604e-e918-4b4c-ac80-f657b8bff1b1\",\n              \"price\" : {\n                \"amount\" : 1500,\n                \"currency\" : \"USD\"\n              },\n              \"isSoldOut\" : true,\n              \"description\" : \"\",\n              \"modifierGroups\" : [\n\n              ],\n              \"name\" : \"Smoked Salmon Benedict\",\n              \"attributes\" : [\n                \"Served until 4pm\"\n              ]\n            },\n            {\n              \"id\" : \"44721836-e458-4967-9aaf-2b80e334e532\",\n              \"price\" : {\n                \"amount\" : 1400,\n                \"currency\" : \"USD\"\n              },\n              \"isSoldOut\" : true,\n              \"description\" : \"with maple syrup & side of fruit\",\n              \"modifierGroups\" : [\n\n              ],\n              \"name\" : \"French Toast\",\n              \"attributes\" : [\n                \"Served until 4pm\"\n              ]\n            },\n            {\n              \"price\" : {\n                \"amount\" : 1400,\n                \"currency\" : \"USD\"\n              },\n              \"id\" : \"015f1b4d-cf20-4655-9eca-d1be56f6531d\",\n              \"modifierGroups\" : [\n                {\n                  \"id\" : \"131f897a-99fb-40e0-98d8-93e450eb2e53\",\n                  \"multipleSelection\" : true,\n                  \"name\" : \"Omelette Add Ons\",\n                  \"modifiers\" : [\n                    {\n                      \"id\" : \"7679a591-b4ec-4723-81dd-6bf16b8c181e\",\n                      \"name\" : \"Add Ham\",\n                      \"description\" : \"\",\n                      \"price\" : {\n                        \"amount\" : 100,\n                        \"currency\" : \"USD\"\n                      }\n                    },\n                    {\n                      \"id\" : \"e776611b-deb4-41c7-8a60-088b6cc70ab6\",\n                      \"name\" : \"Add Bacon\",\n                      \"description\" : \"\",\n                      \"price\" : {\n                        \"amount\" : 100,\n                        \"currency\" : \"USD\"\n                      }\n                    },\n                    {\n                      \"id\" : \"65a4cde9-f96d-487a-a353-2ea87376cbb8\",\n                      \"name\" : \"Add Goat Cheese\",\n                      \"description\" : \"\",\n                      \"price\" : {\n                        \"amount\" : 100,\n                        \"currency\" : \"USD\"\n                      }\n                    },\n                    {\n                      \"id\" : \"c25d2230-8674-4a8c-8ff6-3e91b54bd4c4\",\n                      \"name\" : \"Add Gruyere\",\n                      \"description\" : \"\",\n                      \"price\" : {\n                        \"amount\" : 100,\n                        \"currency\" : \"USD\"\n                      }\n                    },\n                    {\n                      \"id\" : \"811a7eb7-5f1e-4504-b21a-24bd988c807e\",\n                      \"name\" : \"Add Tomatoes\",\n                      \"description\" : \"\",\n                      \"price\" : {\n                        \"amount\" : 100,\n                        \"currency\" : \"USD\"\n                      }\n                    },\n                    {\n                      \"id\" : \"bee2a955-4dea-4219-816e-afabcc13912a\",\n                      \"name\" : \"Add Mushrooms\",\n                      \"description\" : \"\",\n                      \"price\" : {\n                        \"amount\" : 100,\n                        \"currency\" : \"USD\"\n                      }\n                    },\n                    {\n                      \"id\" : \"ceaffc27-cc71-411a-90e7-b66576075887\",\n                      \"name\" : \"Add Spinach\",\n                      \"description\" : \"\",\n                      \"price\" : {\n                        \"amount\" : 100,\n                        \"currency\" : \"USD\"\n                      }\n                    }\n                  ]\n                }\n              ],\n              \"name\" : \"Omelette\",\n              \"description\" : \"Make your own 3 eggs omelette with french fries & salad\",\n              \"attributes\" : [\n                \"Served until 4pm\"\n              ]\n            },\n            {\n              \"price\" : {\n                \"amount\" : 1300,\n                \"currency\" : \"USD\"\n              },\n              \"id\" : \"a1f2da42-ea1b-43b0-bef5-11be73eb2a56\",\n              \"modifierGroups\" : [\n\n              ],\n              \"name\" : \"Gazpacho\",\n              \"description\" : \"Classic Tomato Gazpacho & Toasted Garlic Bread\",\n              \"attributes\" : [\n\n              ]\n            },\n            {\n              \"price\" : {\n                \"amount\" : 1500,\n                \"currency\" : \"USD\"\n              },\n              \"id\" : \"c9bf57d2-52d8-420c-aa49-4686adf4f6c5\",\n              \"modifierGroups\" : [\n\n              ],\n              \"name\" : \"Croque Monsieur\",\n              \"description\" : \"Grilled Open Face Ham & Cheese Sandwich Served With Organic Mixed Green\",\n              \"attributes\" : [\n\n              ]\n            },\n            {\n              \"id\" : \"0f4ab9e0-355f-4620-bae3-7b5fcbf346f9\",\n              \"price\" : {\n                \"amount\" : 800,\n                \"currency\" : \"USD\"\n              },\n              \"isSoldOut\" : true,\n              \"description\" : \"\",\n              \"modifierGroups\" : [\n\n              ],\n              \"name\" : \"Creme Brulée\",\n              \"attributes\" : [\n\n              ]\n            },\n            {\n              \"price\" : {\n                \"amount\" : 1700,\n                \"currency\" : \"USD\"\n              },\n              \"id\" : \"5a0538dc-2954-41e0-b680-03cb6aae28b2\",\n              \"modifierGroups\" : [\n                {\n                  \"minChoices\" : 1,\n                  \"id\" : \"05a6ebd6-a41a-482e-b590-876623a499a7\",\n                  \"modifiers\" : [\n                    {\n                      \"id\" : \"1d0b25bc-c5d2-4410-90c0-49c7e64487c9\",\n                      \"name\" : \"Sunny Side Up\",\n                      \"description\" : \"\"\n                    },\n                    {\n                      \"id\" : \"07e13096-1ba5-4b99-9861-9ffa1eb82501\",\n                      \"name\" : \"Over Easy\",\n                      \"description\" : \"\"\n                    },\n                    {\n                      \"id\" : \"e93f13ed-2d1f-4ffd-b1f8-5b1aff2809c0\",\n                      \"name\" : \"Over Medium\",\n                      \"description\" : \"\"\n                    },\n                    {\n                      \"id\" : \"90431592-f159-4b43-b9e3-fda0234e34de\",\n                      \"name\" : \"Over Hard\",\n                      \"description\" : \"\"\n                    },\n                    {\n                      \"id\" : \"a20d6817-f829-4d84-bd28-5882c96512bb\",\n                      \"name\" : \"Scrambled\",\n                      \"description\" : \"\"\n                    }\n                  ],\n                  \"name\" : \"Egg Styles\",\n                  \"required\" : true,\n                  \"maxChoices\" : 1\n                }\n              ],\n              \"name\" : \"Croque Monsier w\\/ Egg\",\n              \"description\" : \"Grilled Open Face Ham & Cheese Sandwich Served With Organic Mixed Green\",\n              \"attributes\" : [\n\n              ]\n            },\n            {\n              \"price\" : {\n                \"amount\" : 1500,\n                \"currency\" : \"USD\"\n              },\n              \"id\" : \"858d6b33-7234-4f80-aa19-88b5b11d8322\",\n              \"modifierGroups\" : [\n\n              ],\n              \"name\" : \"Quiche Lorraine\",\n              \"description\" : \"Quiche Ham & Cheese Served With Organic Mixed Green\",\n              \"attributes\" : [\n\n              ]\n            },\n            {\n              \"price\" : {\n                \"amount\" : 1500,\n                \"currency\" : \"USD\"\n              },\n              \"id\" : \"766a1f32-8a41-495c-9bf6-709d0a2bd266\",\n              \"modifierGroups\" : [\n                {\n                  \"id\" : \"4d811973-ba4e-412d-b5ee-cca19a89cfca\",\n                  \"multipleSelection\" : true,\n                  \"name\" : \"Salad Add On\",\n                  \"modifiers\" : [\n                    {\n                      \"id\" : \"46172ffc-8cbc-494c-99f6-c4851c88100c\",\n                      \"name\" : \"Add Chicken\",\n                      \"description\" : \"\",\n                      \"price\" : {\n                        \"amount\" : 400,\n                        \"currency\" : \"USD\"\n                      }\n                    },\n                    {\n                      \"id\" : \"5ee3ad2c-e816-4f87-8611-30d7938ca3b4\",\n                      \"name\" : \"Add Tiger Prawns\",\n                      \"description\" : \"\",\n                      \"price\" : {\n                        \"amount\" : 400,\n                        \"currency\" : \"USD\"\n                      }\n                    }\n                  ]\n                }\n              ],\n              \"name\" : \"Salade de Truite Fumee\",\n              \"description\" : \"Flakes Of Smoked Trout With Mâche, Fingerling Potato Coins, Shaved Red Onion, & Toasted Pumpkin Seeds\",\n              \"attributes\" : [\n\n              ]\n            },\n            {\n              \"price\" : {\n                \"amount\" : 1600,\n                \"currency\" : \"USD\"\n              },\n              \"id\" : \"6990b18f-f791-48b8-8ff5-13cb3219477b\",\n              \"modifierGroups\" : [\n                {\n                  \"id\" : \"4d811973-ba4e-412d-b5ee-cca19a89cfca\",\n                  \"multipleSelection\" : true,\n                  \"name\" : \"Salad Add On\",\n                  \"modifiers\" : [\n                    {\n                      \"id\" : \"46172ffc-8cbc-494c-99f6-c4851c88100c\",\n                      \"name\" : \"Add Chicken\",\n                      \"description\" : \"\",\n                      \"price\" : {\n                        \"amount\" : 400,\n                        \"currency\" : \"USD\"\n                      }\n                    },\n                    {\n                      \"id\" : \"5ee3ad2c-e816-4f87-8611-30d7938ca3b4\",\n                      \"name\" : \"Add Tiger Prawns\",\n                      \"description\" : \"\",\n                      \"price\" : {\n                        \"amount\" : 400,\n                        \"currency\" : \"USD\"\n                      }\n                    }\n                  ]\n                }\n              ],\n              \"name\" : \"Salade Nicoise\",\n              \"description\" : \"Organic Mixed Green With Ahi Tuna, Olives, Potatoes, Green Beans, Tomatoes And Hard Boiled Egg & Fresh Anchovies\",\n              \"attributes\" : [\n\n              ]\n            },\n            {\n              \"price\" : {\n                \"amount\" : 1200,\n                \"currency\" : \"USD\"\n              },\n              \"id\" : \"11d27d51-7033-4357-8629-c74801dad618\",\n              \"modifierGroups\" : [\n                {\n                  \"id\" : \"4d811973-ba4e-412d-b5ee-cca19a89cfca\",\n                  \"multipleSelection\" : true,\n                  \"name\" : \"Salad Add On\",\n                  \"modifiers\" : [\n                    {\n                      \"id\" : \"46172ffc-8cbc-494c-99f6-c4851c88100c\",\n                      \"name\" : \"Add Chicken\",\n                      \"description\" : \"\",\n                      \"price\" : {\n                        \"amount\" : 400,\n                        \"currency\" : \"USD\"\n                      }\n                    },\n                    {\n                      \"id\" : \"5ee3ad2c-e816-4f87-8611-30d7938ca3b4\",\n                      \"name\" : \"Add Tiger Prawns\",\n                      \"description\" : \"\",\n                      \"price\" : {\n                        \"amount\" : 400,\n                        \"currency\" : \"USD\"\n                      }\n                    }\n                  ]\n                }\n              ],\n              \"name\" : \"Butter Lettuce Salade\",\n              \"description\" : \"Organic Butter Lettuce Cups With Fresh Herbs, Shallots & Champagne Vinaigrette \",\n              \"attributes\" : [\n\n              ]\n            },\n            {\n              \"price\" : {\n                \"amount\" : 1100,\n                \"currency\" : \"USD\"\n              },\n              \"id\" : \"9fc9696e-615e-4e2c-9df3-b654ae2fe467\",\n              \"modifierGroups\" : [\n\n              ],\n              \"name\" : \"Soup Du Jour\",\n              \"description\" : \"Today\'s Seasonal Soup\",\n              \"attributes\" : [\n\n              ]\n            },\n            {\n              \"price\" : {\n                \"amount\" : 1200,\n                \"currency\" : \"USD\"\n              },\n              \"id\" : \"2c6ef4a8-88fe-422c-a2fc-edda26d1f43d\",\n              \"modifierGroups\" : [\n\n              ],\n              \"name\" : \"Onion Soup\",\n              \"description\" : \"Traditional Onion Soup With Cheese & Toasted Bread\",\n              \"attributes\" : [\n\n              ]\n            },\n            {\n              \"price\" : {\n                \"amount\" : 2800,\n                \"currency\" : \"USD\"\n              },\n              \"id\" : \"bc3f9fa4-56cb-4576-95c9-ae6fd28a5e9e\",\n              \"modifierGroups\" : [\n\n              ],\n              \"name\" : \"Boeuf Bourguignon\",\n              \"description\" : \"Classic Beef Stew With Pinot Noir & Organic Vegetables\",\n              \"attributes\" : [\n\n              ]\n            },\n            {\n              \"price\" : {\n                \"amount\" : 2800,\n                \"currency\" : \"USD\"\n              },\n              \"id\" : \"496d88ae-9787-4469-9161-49b62baab760\",\n              \"modifierGroups\" : [\n\n              ],\n              \"name\" : \"Canard Confit\",\n              \"description\" : \"Slow Cooked Duck Leg, Chimichurri Sauce, Lentils With Diced Vegetables\",\n              \"attributes\" : [\n\n              ]\n            },\n            {\n              \"price\" : {\n                \"amount\" : 2500,\n                \"currency\" : \"USD\"\n              },\n              \"id\" : \"2685bfc8-7d78-4093-b7e9-83743d191832\",\n              \"modifierGroups\" : [\n\n              ],\n              \"name\" : \"Poulet Roti\",\n              \"description\" : \"Roasted Chicken With Black Truffles Sauce, Mashed Potatoes & Green Beans\",\n              \"attributes\" : [\n\n              ]\n            },\n            {\n              \"price\" : {\n                \"amount\" : 3200,\n                \"currency\" : \"USD\"\n              },\n              \"id\" : \"08ea44b6-5fac-4786-9b8c-285dbd3e6c80\",\n              \"modifierGroups\" : [\n\n              ],\n              \"name\" : \"Braised Short Ribs\",\n              \"description\" : \"Roasted With Truffle Mashed Potato & Brocoli Rabe\",\n              \"attributes\" : [\n\n              ]\n            },\n            {\n              \"price\" : {\n                \"amount\" : 2100,\n                \"currency\" : \"USD\"\n              },\n              \"id\" : \"01c8d304-f07e-4c4a-bd0d-29bcf52def5b\",\n              \"modifierGroups\" : [\n\n              ],\n              \"name\" : \"Raviole de Potiron\",\n              \"description\" : \"Butternut Squash Ravioli With Porcini Mushroom Cream Sauce\",\n              \"attributes\" : [\n\n              ]\n            },\n            {\n              \"price\" : {\n                \"amount\" : 2800,\n                \"currency\" : \"USD\"\n              },\n              \"id\" : \"fcd45a9d-2fd0-4578-83af-6119efbded62\",\n              \"modifierGroups\" : [\n\n              ],\n              \"name\" : \"Blanquette de Veau\",\n              \"description\" : \"Veal Stew With Rice, Carrots, Button Mushrooms & Pearl Onions\",\n              \"attributes\" : [\n\n              ]\n            },\n            {\n              \"price\" : {\n                \"amount\" : 2800,\n                \"currency\" : \"USD\"\n              },\n              \"id\" : \"3080a68e-6a97-48b3-abd1-f636ea564cc4\",\n              \"modifierGroups\" : [\n\n              ],\n              \"name\" : \"Saumon a la Parisienne\",\n              \"description\" : \"Atlantic Salmon Served With Wild Mushroom Risotto\",\n              \"attributes\" : [\n\n              ]\n            },\n            {\n              \"price\" : {\n                \"amount\" : 2900,\n                \"currency\" : \"USD\"\n              },\n              \"id\" : \"943aba79-37a7-41e9-ac22-d243a85ce83b\",\n              \"modifierGroups\" : [\n                {\n                  \"minChoices\" : 1,\n                  \"id\" : \"5a8a23b0-1d7e-4829-ba1c-064e7c761135\",\n                  \"modifiers\" : [\n                    {\n                      \"id\" : \"e91fce94-c3e2-4ba6-833e-513056c19550\",\n                      \"name\" : \"Rare\",\n                      \"description\" : \"\"\n                    },\n                    {\n                      \"id\" : \"be5de2fb-9c84-4504-8a3f-fd94771884cd\",\n                      \"name\" : \"Medium Rare\",\n                      \"description\" : \"\"\n                    },\n                    {\n                      \"id\" : \"df9df33f-0798-4c6e-8f07-8530f34960ef\",\n                      \"name\" : \"Medium\",\n                      \"description\" : \"\"\n                    },\n                    {\n                      \"id\" : \"8e7733ac-1775-4d70-b179-6287393dd344\",\n                      \"name\" : \"Medium Well\",\n                      \"description\" : \"\"\n                    },\n                    {\n                      \"id\" : \"b083fa12-ec25-46b8-9679-243b1fe66353\",\n                      \"name\" : \"Well Done\",\n                      \"description\" : \"\"\n                    }\n                  ],\n                  \"name\" : \"Meat Temperature\",\n                  \"required\" : true,\n                  \"maxChoices\" : 1\n                }\n              ],\n              \"name\" : \"Steak Frites\",\n              \"description\" : \"Grilled N.Y Steak & French Fries\",\n              \"attributes\" : [\n\n              ]\n            },\n            {\n              \"price\" : {\n                \"amount\" : 1600,\n                \"currency\" : \"USD\"\n              },\n              \"id\" : \"1b6d5874-2c52-4571-935e-1a10d2eceae2\",\n              \"modifierGroups\" : [\n                {\n                  \"minChoices\" : 1,\n                  \"id\" : \"5a8a23b0-1d7e-4829-ba1c-064e7c761135\",\n                  \"modifiers\" : [\n                    {\n                      \"id\" : \"e91fce94-c3e2-4ba6-833e-513056c19550\",\n                      \"name\" : \"Rare\",\n                      \"description\" : \"\"\n                    },\n                    {\n                      \"id\" : \"be5de2fb-9c84-4504-8a3f-fd94771884cd\",\n                      \"name\" : \"Medium Rare\",\n                      \"description\" : \"\"\n                    },\n                    {\n                      \"id\" : \"df9df33f-0798-4c6e-8f07-8530f34960ef\",\n                      \"name\" : \"Medium\",\n                      \"description\" : \"\"\n                    },\n                    {\n                      \"id\" : \"8e7733ac-1775-4d70-b179-6287393dd344\",\n                      \"name\" : \"Medium Well\",\n                      \"description\" : \"\"\n                    },\n                    {\n                      \"id\" : \"b083fa12-ec25-46b8-9679-243b1fe66353\",\n                      \"name\" : \"Well Done\",\n                      \"description\" : \"\"\n                    }\n                  ],\n                  \"name\" : \"Meat Temperature\",\n                  \"required\" : true,\n                  \"maxChoices\" : 1\n                },\n                {\n                  \"id\" : \"133fbba1-9fa4-4231-b4ae-0523601d4e4b\",\n                  \"multipleSelection\" : true,\n                  \"name\" : \"Burger Add Ons\",\n                  \"modifiers\" : [\n                    {\n                      \"id\" : \"a85d1c03-3f39-4f0e-aea2-bb475b0d27c2\",\n                      \"name\" : \"Add Swiss\",\n                      \"description\" : \"\",\n                      \"price\" : {\n                        \"amount\" : 100,\n                        \"currency\" : \"USD\"\n                      }\n                    },\n                    {\n                      \"id\" : \"60fe415f-9e74-440b-9e7e-dd6b32f9e1c9\",\n                      \"name\" : \"Add Cheddar\",\n                      \"description\" : \"\",\n                      \"price\" : {\n                        \"amount\" : 100,\n                        \"currency\" : \"USD\"\n                      }\n                    },\n                    {\n                      \"id\" : \"d5a998ec-cd93-416f-9d15-3d837ea4b634\",\n                      \"name\" : \"Add Blue Cheese\",\n                      \"description\" : \"\",\n                      \"price\" : {\n                        \"amount\" : 100,\n                        \"currency\" : \"USD\"\n                      }\n                    },\n                    {\n                      \"id\" : \"53a03721-1c2d-4898-8b49-b000875cf4c9\",\n                      \"name\" : \"Add Bacon\",\n                      \"description\" : \"\",\n                      \"price\" : {\n                        \"amount\" : 200,\n                        \"currency\" : \"USD\"\n                      }\n                    },\n                    {\n                      \"id\" : \"0b08d551-9666-4d07-b04d-af10876dde30\",\n                      \"name\" : \"Add Egg\",\n                      \"description\" : \"\",\n                      \"price\" : {\n                        \"amount\" : 200,\n                        \"currency\" : \"USD\"\n                      }\n                    }\n                  ]\n                }\n              ],\n              \"name\" : \"Burger\",\n              \"description\" : \"With Pommes Frites, Butter Lettuce, Organic Tomato, Pickle, Onions, and Harissa Aïoli\",\n              \"attributes\" : [\n\n              ]\n            },\n            {\n              \"price\" : {\n                \"amount\" : 900,\n                \"currency\" : \"USD\"\n              },\n              \"id\" : \"b55cc3a7-3ec5-4dab-b888-4cfd19337bf1\",\n              \"modifierGroups\" : [\n\n              ],\n              \"name\" : \"Chocolate Fondant With Vanilla Ice Cream\",\n              \"description\" : \"\",\n              \"attributes\" : [\n\n              ]\n            },\n            {\n              \"price\" : {\n                \"amount\" : 900,\n                \"currency\" : \"USD\"\n              },\n              \"id\" : \"6aad11af-0186-448b-b9cc-3a7d741d3c6e\",\n              \"modifierGroups\" : [\n\n              ],\n              \"name\" : \"Apple Tatin With Vanilla Ice Cream\",\n              \"description\" : \"\",\n              \"attributes\" : [\n\n              ]\n            },\n            {\n              \"price\" : {\n                \"amount\" : 900,\n                \"currency\" : \"USD\"\n              },\n              \"id\" : \"5322bd8e-613c-4bd5-9869-4fb2aea61590\",\n              \"modifierGroups\" : [\n\n              ],\n              \"name\" : \"Lemon Tart\",\n              \"description\" : \"\",\n              \"attributes\" : [\n\n              ]\n            },\n            {\n              \"id\" : \"6ff1fd02-ee6a-4fa9-9656-1a2a9444f381\",\n              \"price\" : {\n                \"amount\" : 1400,\n                \"currency\" : \"USD\"\n              },\n              \"isSoldOut\" : true,\n              \"description\" : \"w\\/ Spinach\",\n              \"modifierGroups\" : [\n\n              ],\n              \"name\" : \"Eggs Florentine\",\n              \"attributes\" : [\n                \"Served until 4pm\"\n              ]\n            },\n            {\n              \"price\" : {\n                \"amount\" : 3200,\n                \"currency\" : \"USD\"\n              },\n              \"id\" : \"373141a0-f8d7-4063-bfcf-52cd46d1ca05\",\n              \"modifierGroups\" : [\n\n              ],\n              \"name\" : \"Rack of Lamb\",\n              \"description\" : \"Rack of Lamb with polenta & spinach in Porto sauce\",\n              \"attributes\" : [\n\n              ]\n            }\n          ],\n          \"description\" : \"\"\n        }\n      ]\n    }\n  ]\n}"

