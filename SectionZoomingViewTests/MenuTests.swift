import Foundation
import XCTest
@testable import SectionZoomingView

class MenuTests: XCTestCase {
    // Make sure it doesn't blow up
    func testMenuDecoding() throws {
        XCTAssertNoThrow(try TakeoutDataSource(example: .coquetta_11_31))
    }
}
