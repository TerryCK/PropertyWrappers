import PropertyWrappers
import XCTest

final class LazyTests: XCTestCase {
  func testLazyInitializesValue() {
    var sut = LazyContainer(lazyValue: 42)
    XCTAssertEqual(sut.lazyValue, 42)
  }

  func testLazyCallsInitializerLazily() {
    var sut = LazyContainer(lazyValue: 23)
    assertIsUninitialized(sut.$lazyValue)
    XCTAssertEqual(sut.lazyValue, 23)
    assertIsInitialized(sut.$lazyValue)
  }
  
  func testLazyDoesntCallInitializerWhenSetterIsInvokedFirst() {
    // See my bug report: SR-10950: Property wrappers: @autoclosure not working?
    // https://bugs.swift.org/browse/SR-10950
    XCTFail("I don't know how to test this")
  }
}

/// Container struct because local vars can't be property wrappers yet.
fileprivate struct LazyContainer {
  @Lazy var lazyValue: Int
}

/// Asserts that a `Lazy` value is .unintialized.
private func assertIsUninitialized<Value>(_ lazyValue: Lazy<Value>, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
  switch lazyValue {
  case .uninitialized:
    // Do nothing
    break
  case .initialized:
    XCTFail("\(lazyValue) is not .uninitialized – \(message())", file: file, line: line)
  }
}

/// Asserts that a `Lazy` value is .initialized.
private func assertIsInitialized<Value>(_ lazyValue: Lazy<Value>, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
  switch lazyValue {
  case .uninitialized:
    XCTFail("\(lazyValue) is not .initialized – \(message())", file: file, line: line)
  case .initialized:
    // Do nothing
    break
  }
}