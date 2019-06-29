import Foundation

/// A property wrapper that stores its value directly in user defaults.
///
/// The `Value` type specifies how it stores itself as a property list object
/// via its `PropertyListConvertible` conformance. To store your own type in user defaults,
/// conform it to `PropertyListConvertible`.
///
/// Usage:
///
///     @UserDefault(key: "locationTrackingEnabled", defaultValue: false)
///     var isLocationTrackingEnabled: Bool
///
///     @UserDefault(key: "colorScheme", defaultValue: .solarizedDark)
///     var colorScheme: ColorScheme
///
/// Unless otherwise specified, defaults values are read from and written to `UserDefaults.standard`.
/// You can override this by passing an explicit `UserDefaults` instance to the initializer:
///
///     @UserDefault var localeIdentifier: String
///     ...
///     let myDefaults = UserDefaults(...)
///     $localeIdentifier = (key: "localeIdentifier", defaultValue: "en_US", userDefaults: myDefaults)
///
/// Source: Extended from a base implementation shown in [Swift Evolution proposal SE-0258](https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md)
@propertyWrapper
public struct UserDefault<Value: PropertyListConvertible> {
  public let key: String
  public let defaultValue: () -> Value
  public let userDefaults: UserDefaults

  public init(key: String, defaultValue: @autoclosure @escaping () -> Value, userDefaults: UserDefaults = .standard) {
    self.key = key
    self.defaultValue = defaultValue
    self.userDefaults = userDefaults
  }

  public var value: Value {
    get {
      guard let plistValue = userDefaults.object(forKey: key) as? Value.PropertyListStorage,
        let value = Value(propertyListValue: plistValue)
        else { return defaultValue() }
      return value
    }
    nonmutating set {
      userDefaults.set(newValue.propertyListValue, forKey: key)
    }
  }
}

/// A type that can convert itself to and from a plist-compatible type (for storage in a plist).
public protocol PropertyListConvertible {
  /// The type that's used for storage in the plist.
  ///
  /// Must be a plist-compatible type:
  /// - Dictionary/NSDictionary (Key and Value must be plist types)
  /// - Array/NSArray (Element must be a plist type)
  /// - String/NSString
  /// - A numeric type that's convertible to NSNumber
  /// - Bool
  /// - Date/NSDate
  /// - Data/NSData
  ///
  /// See https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/PropertyList.html
  associatedtype PropertyListStorage

  init?(propertyListValue: PropertyListStorage)
  var propertyListValue: PropertyListStorage { get }
}

extension PropertyListConvertible where PropertyListStorage == Self {
  public init?(propertyListValue: Self) {
    self = propertyListValue
  }

  public var propertyListValue: Self { self }
}

extension String: PropertyListConvertible {}
extension Int: PropertyListConvertible {}
extension Int8: PropertyListConvertible {}
extension Int16: PropertyListConvertible {}
extension Int32: PropertyListConvertible {}
extension Int64: PropertyListConvertible {}
extension UInt: PropertyListConvertible {}
extension UInt8: PropertyListConvertible {}
extension UInt16: PropertyListConvertible {}
extension UInt32: PropertyListConvertible {}
extension UInt64: PropertyListConvertible {}
extension Float: PropertyListConvertible {}
extension Double: PropertyListConvertible {}
extension Bool: PropertyListConvertible {}
extension Date: PropertyListConvertible {}
extension Data: PropertyListConvertible {}

extension Array: PropertyListConvertible where Element: PropertyListConvertible {
  public typealias PropertyListStorage = Self
}

extension Dictionary: PropertyListConvertible where Key: PropertyListConvertible, Value: PropertyListConvertible {
  public typealias PropertyListStorage = Self
}
