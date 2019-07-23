import PropertyWrappers
import XCTest

final class CopyOnWriteTests: XCTestCase {
  func testDoesntMakeCopyIfUniquelyReferenced() {
    var sut = CopyOnWriteContainer()
    let beforeMutation = ObjectIdentifier(sut.friend)
    sut.friend.name = "Barbara"
    let afterMutation = ObjectIdentifier(sut.friend)
    XCTAssertEqual(beforeMutation, afterMutation)
  }

  func testMakesCopyIfNotUniquelyReferenced() {
    var sut = CopyOnWriteContainer()
    let beforeMutation = ObjectIdentifier(sut.friend)
    let copy = sut
    sut.friend.name = "Barbara"
    let afterMutation = ObjectIdentifier(sut.friend)
    XCTAssertNotEqual(beforeMutation, afterMutation)
    withExtendedLifetime(copy) { }
  }
}

/// Container type because local vars can't be property wrappers yet.
fileprivate struct CopyOnWriteContainer {
  @CopyOnWrite var friend = Person(name: "Alice")
}

fileprivate final class Person: Copyable {
  var name: String

  init(name: String) {
    self.name = name
  }

  func copy() -> Person {
    return Person(name: name)
  }
}
