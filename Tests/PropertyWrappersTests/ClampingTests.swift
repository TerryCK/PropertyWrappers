import PropertyWrappers
import XCTest

final class ClampingTests: XCTestCase {
  func testClampingReturnsMinIfTooSmall() {
    var sut = ClampingContainer()
    XCTAssertEqual(sut.percentage, 0.5)
    sut.percentage = -0.1
    XCTAssertEqual(sut.percentage, 0)
  }

  func testClampingReturnsMaxIfTooLarge() {
    var sut = ClampingContainer()
    XCTAssertEqual(sut.percentage, 0.5)
    sut.percentage = 1.1
    XCTAssertEqual(sut.percentage, 1)
  }
}

/// Container type because local vars can't be property wrappers yet.
fileprivate struct ClampingContainer {
  @Clamping(range: 0...1) var percentage: Double = 0.5
}
