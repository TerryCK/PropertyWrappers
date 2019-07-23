import PropertyWrappers
import XCTest

final class RefTests: XCTestCase {
  override func setUp() {
    super.setUp()
    favoriteNumber = 0
    friend = Person(name: "Alice")
  }

  func testRefReadsCapturedValue() {
    let sut = RefContainer()
    XCTAssertEqual(sut.favoriteNumberRef, 0)
    favoriteNumber = 42
    XCTAssertEqual(sut.favoriteNumberRef, 42)
  }

  func testRefWritesCapturedValue() {
    let sut = RefContainer()
    XCTAssertEqual(sut.favoriteNumberRef, 0)
    sut.favoriteNumberRef = 100
    XCTAssertEqual(favoriteNumber, 100)
  }

  func testTwoRefsShareSameVariable() {
    let sut = RefContainer()
    XCTAssertEqual(sut.favoriteNumberRef, 0)
    sut.bestNumberRef = 777
    XCTAssertEqual(sut.favoriteNumberRef, 777)
  }

  func testDrillDownIntoRef() {
    let sut = RefContainer()
    XCTAssertEqual(sut.friendRef, Person(name: "Alice"))
    sut.friendRef.name = "Barbara"
    XCTAssertEqual(sut.friendRef, Person(name: "Barbara"))
    XCTAssertEqual(friend, Person(name: "Barbara"))
  }
}

fileprivate var favoriteNumber: Int = 0
fileprivate var friend: Person = Person(name: "Alice")

/// Container type because local vars can't be property wrappers yet.
fileprivate struct RefContainer {
  @Ref(read: { favoriteNumber }, write: { favoriteNumber = $0 })
  var favoriteNumberRef: Int

  @Ref(read: { favoriteNumber }, write: { favoriteNumber = $0 })
  var bestNumberRef: Int

  @Ref(read: { friend }, write: { friend = $0 })
  var friendRef: Person
}

fileprivate struct Person: Equatable {
  var name: String
}
