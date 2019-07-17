import PropertyWrappers
import XCTest

final class DelayedInitTests: XCTestCase {
  func testDelayedLetInitializesOnSet() {
    let sut = DelayedInitContainer()
    sut.greeting = "Hello world"
    XCTAssertEqual(sut.greeting, "Hello world")
  }

  func _testDelayedLetTrapsOnGetBeforeSet() {
    // Can't test for trapping.
  }

  func _testDelayedLetTrapsOnDoubleInit() {
    // Can't test for trapping.
  }

  func testDelayedVarInitializesOnSet() {
    let sut = DelayedInitContainer()
    sut.favoriteNumber = 42
    XCTAssertEqual(sut.favoriteNumber, 42)
  }

  func _testDelayedVarTrapsOnGetBeforeSet() {
    // Can't test for trapping.
  }

  func _testDelayedVarTrapsAfterReset() {
    // Can't test for trapping.
  }

  func testDelayedVarResetReleasesValue() {
    let sut = DelayedInitContainer()
    sut.object = NSObject()
    weak var object: NSObject? = sut.object
    XCTAssertNotNil(object)
    sut.objectWrapper.reset()
    XCTAssertNil(object)
  }
}

/// Container struct because local vars can't be property wrappers yet.
fileprivate class DelayedInitContainer {
  @DelayedLet var greeting: String
  @DelayedVar var favoriteNumber: Int
  @DelayedVar var object: NSObject

  /// Republishing synthesized storage property because it's private
  var objectWrapper: DelayedVar<NSObject> {
    get { _object }
    set { _object = newValue }
  }
}
