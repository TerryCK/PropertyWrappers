/// A property wrapper for delayed initialization. Enforces the definite initialization rules dynamically at runtime
/// rather than at compile time.
///
/// A `@DelayedLet` property doesn't have to be initialized at initialization of its containing type. You must assign
/// a value _exactly once_ and _before_ accessing the value for the first time. Reading the value before setting it or
/// assigning a value more than once results in a runtime failure.
///
/// Source: [Swift Evolution proposal SE-0258](https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md#delayed-initialization)
///
/// - Seealso: `DelayedVar`
@propertyWrapper
public struct DelayedLet<Value> {
  private var _value: Value? = nil

  public init() {}

  public var value: Value {
    get {
      guard let value = _value else {
        fatalError("DelayedLet: property accessed before being initialized")
      }
      return value
    }

    // Perform initialization. Trap if the value is already initialized.
    set {
      if _value != nil {
        fatalError("DelayedLet: property initialized twice")
      }
      _value = newValue
    }
  }
}


/// A property wrapper for delayed initialization. Enforces the definite initialization rules dynamically at runtime
/// rather than at compile time.
///
/// A `@DelayedVar` property doesn't have to be initialized at initialization of its containing type. You must assign
/// a value _before_ accessing the value for the first time. Reading the value before setting it results in a runtime failure.
/// Unlike `@DelayedLet`, a `@DelayedVar` can be assigned to multiple times.
///
/// Source: [Swift Evolution proposal SE-0258](https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md#delayed-initialization)
///
/// - Seealso: `DelayedLet`
@propertyWrapper
public struct DelayedVar<Value> {
  private var _value: Value? = nil

  public init() {}

  public var value: Value {
    get {
      guard let value = _value else {
        fatalError("DelayedVar: property accessed before being initialized")
      }
      return value
    }
    set {
      _value = newValue
    }
  }

  /// "Resets" the wrapped value so it can be initialized again.
  /// This can be useful if you want to free up resources held by the current value without assigning a new one right away.
  public mutating func reset() {
    _value = nil
  }
}
