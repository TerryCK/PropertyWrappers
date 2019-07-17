import PropertyWrappers
import XCTest

final class UserDefaultsTests: XCTestCase {
  private var defaults: UserDefaults!
  private var sut: UserDefaultContainer!

  override func setUp() {
    super.setUp()
    defaults = UserDefaults(suiteName: "unit-tests")!
    // Clear user defaults before each test
    defaults.removePersistentDomain(forName: "unit-tests")
    sut = UserDefaultContainer(defaults: defaults)
  }

  override func tearDown() {
    super.tearDown()
    defaults.removePersistentDomain(forName: "unit-tests")
  }

  func testAssignmentSetsUserDefault() {
    XCTAssertNil(defaults.string(forKey: "test-localeIdentifier"))
    sut.localeIdentifier = "de_DE"
    XCTAssertEqual(defaults.string(forKey: "test-localeIdentifier"), "de_DE")
  }

  func testGetterRetrievesUserDefault() {
    sut.firstLaunch = Date(timeIntervalSinceReferenceDate: 400_000_000)
    XCTAssertEqual(sut.firstLaunch.timeIntervalSinceReferenceDate, 400_000_000)
  }

  func testUsesDefaultValueIfNotSet() {
    XCTAssertEqual(sut.favoriteNumber, 42)
  }

  func testReturnsValueStoredInUserDefaults() {
    defaults.set(23, forKey: "test-favoriteNumber")
    XCTAssertEqual(sut.favoriteNumber, 23)
  }

  func testSetterIsNonmutating() {
    sut.favoriteNumber = 23
    // No assertion needed. The test is that assigning to a let variable compiles.
  }

  func testArray() {
    sut.cities = ["Berlin"]
    sut.cities.append("London")
    XCTAssertEqual(defaults.array(forKey: "test-cities") as? [String], ["Berlin", "London"])
    XCTAssertEqual(sut.cities, ["Berlin", "London"])
  }

  func testArrayOfCustomTypes() {
    sut.tabOrder = [.search, .profile, .timeline]
    XCTAssertEqual(defaults.array(forKey: "test-tabOrder") as? [String], ["search", "profile", "timeline"])
    XCTAssertEqual(sut.tabOrder, [.search, .profile, .timeline])
  }

  func testDictionary() {
    sut.menu = ["File": ["New", "Open", "Save"], "Edit": ["Cut", "Copy", "Paste"]]
    XCTAssertEqual(defaults.dictionary(forKey: "test-menu") as? [String: [String]], ["File": ["New", "Open", "Save"], "Edit": ["Cut", "Copy", "Paste"]])
    XCTAssertEqual(sut.menu, ["File": ["New", "Open", "Save"], "Edit": ["Cut", "Copy", "Paste"]])
  }

  func testCustomType() {
    XCTAssertEqual(sut.selectedTab, .timeline)
    sut.selectedTab = .profile
    XCTAssertEqual(defaults.string(forKey: "test-selectedTab"), "profile")
    XCTAssertEqual(sut.selectedTab, .profile)
  }
}

/// Container struct because local vars can't be property wrappers yet.
fileprivate struct UserDefaultContainer {
  let defaults: UserDefaults

  @UserDefault var favoriteNumber: Int
  @UserDefault var localeIdentifier: String
  @UserDefault var firstLaunch: Date
  @UserDefault var cities: [String]
  @UserDefault var menu: [String: [String]]
  @UserDefault var selectedTab: Tab
  @UserDefault var tabOrder: [Tab]

  init(defaults: UserDefaults) {
    self.defaults = defaults
    _favoriteNumber = UserDefault(key: "test-favoriteNumber", defaultValue: 42, userDefaults: defaults)
    _localeIdentifier = UserDefault(key: "test-localeIdentifier", defaultValue: "en_US", userDefaults: defaults)
    _firstLaunch = UserDefault(key: "test-firstLaunch", defaultValue: Date(timeIntervalSinceReferenceDate: 500_000_000), userDefaults: defaults)
    _cities = UserDefault(key: "test-cities", defaultValue: [], userDefaults: defaults)
    _menu = UserDefault(key: "test-menu", defaultValue: [:], userDefaults: defaults)
    _selectedTab = UserDefault(key: "test-selectedTab", defaultValue: .timeline, userDefaults: defaults)
    _tabOrder = UserDefault(key: "test-tabOrder", defaultValue: [.timeline, .profile, .search], userDefaults: defaults)
  }
}

fileprivate enum Tab: String, PropertyListConvertible {
  case timeline
  case profile
  case search

  init?(propertyListValue: String) {
    self.init(rawValue: propertyListValue)
  }

  var propertyListValue: String {
    return rawValue
  }
}
