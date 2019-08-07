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
    // Register default value with user defaults
    if let defaultValue = defaultValue() as? OptionalProtocol {
      /// `nil` or `NSNull` are not valid property list values.
      // This means we can't register a `nil` default value and we can't distinguish between
      // "value not present" and "values was explicitly set to nil". This makes `nil` the only
      // safe choice as a default value.
      precondition(defaultValue.isNil, """
        The default value for optional UserDefault properties must be nil. \
        nil or NSNull are not valid property list values. This means we can't distinguish between \
        "value not present" and "values was explicitly set to nil". \
        This makes `nil` the only safe choice as a default value.
        """)
      // Do nothing else. We can't register `nil` as the default value.
    } else {
      userDefaults.register(defaults: [key: defaultValue().propertyListValue])
    }
  }

  public var wrappedValue: Value {
    get {
      guard let plistValue = userDefaults.object(forKey: key) as? Value.Storage,
        let value = Value(propertyListValue: plistValue)
        else { return defaultValue() }
      return value
    }
    nonmutating set {
      if let optional = newValue as? OptionalProtocol, optional.isNil {
        userDefaults.removeObject(forKey: key)
      } else {
        userDefaults.set(newValue.propertyListValue, forKey: key)
      }
    }
  }
}

// MARK: - PropertyListConvertible

/// A type that can convert itself to and from a plist-compatible type (for storage in a plist).
public protocol PropertyListConvertible {
  /// The type that's used for storage in the plist.
  associatedtype Storage: PropertyListNativelyStorable

  /// Creates an instance from its property list representation.
  ///
  /// The default implementation for PropertyListStorage == Self uses `propertyListValue` directly as `self`.
  ///
  /// - Returns: `nil` if the conversion failed.
  init?(propertyListValue: Storage)

  /// The property list representation of `self`.
  /// The default implementation for PropertyListStorage == Self returns `self`.
  var propertyListValue: Storage { get }
}

extension PropertyListConvertible where Storage == Self {
  public init?(propertyListValue: Self) {
    self = propertyListValue
  }

  public var propertyListValue: Self { self }
}

/// UUID stores itself as a String
extension UUID: PropertyListConvertible {
  public var propertyListValue: String { uuidString }

  public init?(propertyListValue: Storage) {
    self.init(uuidString: propertyListValue)
  }
}

/// Optionals can be stored in a property list if they wrap a PropertyListConvertible type
///
/// - Note: The default value for optional UserDefault properties must be `nil`.
///   `nil` or `NSNull` are not valid property list values. This means we can't distinguish between
///   "value not present" and "values was explicitly set to nil".
///   This makes `nil` the only safe choice as a default value.
extension Optional: PropertyListConvertible where Wrapped: PropertyListConvertible {
  public var propertyListValue: Wrapped.Storage? {
    return self?.propertyListValue
  }

  public init?(propertyListValue: Wrapped.Storage?) {
    guard let storedValue = propertyListValue else { return nil }
    self = Wrapped(propertyListValue: storedValue)
  }
}

/// Arrays convert themselves to their property list representation by converting each element to its plist representation.
extension Array: PropertyListConvertible where Element: PropertyListConvertible {
  /// Returns `nil` if one or more elements can't be converted.
  public init?(propertyListValue plistArray: [Element.Storage]) {
    var result: [Element] = []
    result.reserveCapacity(plistArray.count)
    for plistElement in plistArray {
      guard let element = Element(propertyListValue: plistElement) else {
        // Abort if one or more elements can't be created.
        return nil
      }
      result.append(element)
    }
    self = result
  }

  public var propertyListValue: [Element.Storage] {
    map { $0.propertyListValue }
  }
}

extension Dictionary: PropertyListConvertible
  where Key: PropertyListConvertible, Value: PropertyListConvertible,
    Key.Storage: Hashable,
    // The Swift 5.1 compiler forced me to add these two constraints, but they don't make much
    // sense to me. They are related to the `Dictionary: PropertyListNativelyStorable` extension.
    // I believe they mae sure that the PropertyListStorage associated type is the same in both
    // extensions.
    Key.Storage == Key.Storage.Storage,
    Value.Storage == Value.Storage.Storage
{
  /// Returns `nil` if one or more elements can't be converted.
  public init?(propertyListValue plistDict: [Key.Storage: Value.Storage]) {
    var result: [Key: Value] = [:]
    result.reserveCapacity(plistDict.count)
    for (plistKey, plistValue) in plistDict {
      guard let key = Key(propertyListValue: plistKey), let value = Value(propertyListValue: plistValue) else {
        // Abort if one or more elements can't be created.
        return nil
      }
      result[key] = value
    }
    self = result
  }

  /// If two or more keys convert to the same key, the result will include only one of those key-value pairs.
  public var propertyListValue: [Key.Storage: Value.Storage] {
    return Dictionary<Key.Storage, Value.Storage>(
      map { ($0.key.propertyListValue, $0.value.propertyListValue) },
      uniquingKeysWith: { $1 })
  }
}

// MARK: - PropertyListNativelyStorable

/// A type that can be natively stored in a property list, i.e. a _property list object_.
///
/// This is a marker protocol, i.e. it has no requirements. You should not conform your own types to it.
/// We already provide the required conformances for the standard plist-compatible types.
///
/// Instances of these types can be property list objects:
///
/// - Dictionary/NSDictionary (Key and Value must be plist types)
/// - Array/NSArray (Element must be a plist type)
/// - String/NSString
/// - A numeric type that's convertible to NSNumber
/// - Bool
/// - Date/NSDate
/// - Data/NSData
///
/// See https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/PropertyList.html
public protocol PropertyListNativelyStorable: PropertyListConvertible {}

extension String: PropertyListNativelyStorable {}
extension Int: PropertyListNativelyStorable {}
extension Int8: PropertyListNativelyStorable {}
extension Int16: PropertyListNativelyStorable {}
extension Int32: PropertyListNativelyStorable {}
extension Int64: PropertyListNativelyStorable {}
extension UInt: PropertyListNativelyStorable {}
extension UInt8: PropertyListNativelyStorable {}
extension UInt16: PropertyListNativelyStorable {}
extension UInt32: PropertyListNativelyStorable {}
extension UInt64: PropertyListNativelyStorable {}
extension Float: PropertyListNativelyStorable {}
extension Double: PropertyListNativelyStorable {}
extension Bool: PropertyListNativelyStorable {}
extension Date: PropertyListNativelyStorable {}
extension Data: PropertyListNativelyStorable {}

extension Optional: PropertyListNativelyStorable where Wrapped: PropertyListNativelyStorable {}

extension Array: PropertyListNativelyStorable where Element: PropertyListNativelyStorable {}

extension Dictionary: PropertyListNativelyStorable where Key: PropertyListNativelyStorable, Value: PropertyListNativelyStorable, Key.Storage == Key, Value.Storage == Value {}

// MARK: - OptionalProtocol

/// A marker protocol for Optionals.
/// Used to identify optional values in type casts in generic contexts.
protocol OptionalProtocol {
  var isNil: Bool { get }
}

extension Optional: OptionalProtocol {
  var isNil: Bool { self == nil }
}
