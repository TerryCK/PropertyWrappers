import PropertyWrappers
import XCTest

final class BoxTests: XCTestCase {
  func testBoxHasReferenceSemantics() {
    let sut = BoxContainer()
    let boxes = [sut.favoriteNumberWrapper, sut.favoriteNumberWrapper]
    XCTAssertEqual(boxes[1].wrappedValue, 0)
    boxes[0].wrappedValue = 42
    XCTAssertEqual(boxes[1].wrappedValue, 42)
  }

  func testBoxProjectedValueReturnsRef() {
    let sut = BoxContainer()
    XCTAssertEqual(sut.favoriteNumber, 0)
    sut.$favoriteNumber.wrappedValue = 23
    XCTAssertEqual(sut.favoriteNumber, 23)
  }
}

/// Container type because local vars can't be property wrappers yet.
fileprivate struct BoxContainer {
  @Box var favoriteNumber: Int = 0

  /// Republishing synthesized storage property because it's private
  var favoriteNumberWrapper: Box<Int> {
    get { _favoriteNumber }
    set { _favoriteNumber = newValue }
  }

}
