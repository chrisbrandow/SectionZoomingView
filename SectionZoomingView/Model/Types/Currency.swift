import Foundation

enum Currency: String, Codable, Equatable {

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
