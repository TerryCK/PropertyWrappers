import PropertyWrappers
import XCTest

final class PropertyWrappersTests: XCTestCase {
  var defaults: UserDefaults!

  override func setUp() {
    super.setUp()
    defaults = UserDefaults(suiteName: "unit-tests")!
    defaults.removePersistentDomain(forName: "unit-tests")
  }

  override func tearDown() {
    super.tearDown()
    defaults.removePersistentDomain(forName: "unit-tests")
  }

  func testAssignmentSetsUserDefault() {
    let sut = UserDefaultContainer(defaults: defaults)
    XCTAssertNil(defaults.string(forKey: "test-localeIdentifier"))
    sut.localeIdentifier = "de_DE"
    XCTAssertEqual(defaults.string(forKey: "test-localeIdentifier"), "de_DE")
  }

  func testGetterRetrievesUserDefault() {
    let sut = UserDefaultContainer(defaults: defaults)
    sut.firstLaunch = Date(timeIntervalSinceReferenceDate: 400_000_000)
    XCTAssertEqual(sut.firstLaunch.timeIntervalSinceReferenceDate, 400_000_000)
  }

  func testUsesDefaultValueIfNotSet() {
    let sut = UserDefaultContainer(defaults: defaults)
    XCTAssertEqual(sut.favoriteNumber, 42)
  }

  func testSetterIsNonmutating() {
    let sut = UserDefaultContainer(defaults: defaults)
    sut.favoriteNumber = 23
    // No assertion needed. The test is that assigning to a let variable compiles.
  }
}

/// Container struct because local vars can't be property wrappers yet.
fileprivate struct UserDefaultContainer {
  let defaults: UserDefaults

  @UserDefault var favoriteNumber: Int
  @UserDefault var localeIdentifier: String
  @UserDefault var firstLaunch: Date

  init(defaults: UserDefaults) {
    self.defaults = defaults
    $favoriteNumber = UserDefault(key: "test-favoriteNumber", defaultValue: 42, userDefaults: defaults)
    $localeIdentifier = UserDefault(key: "test-localeIdentifier", defaultValue: "en_US", userDefaults: defaults)
    $firstLaunch = UserDefault(key: "test-firstLaunch", defaultValue: Date(timeIntervalSinceReferenceDate: 500_000_000), userDefaults: defaults)
  }
}
