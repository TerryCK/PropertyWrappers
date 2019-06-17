import XCTest
@testable import PropertyWrappers

final class PropertyWrappersTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(PropertyWrappers().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
