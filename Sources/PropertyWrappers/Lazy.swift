/// A value that's initialized lazily when it's first accessed.
///
/// This isn't a complete replacement for Swift's built-in `lazy` keyword because, unlike `lazy`, the initial value of a `@Lazy` property can't refer to the `self` of the enclosing type.
///
/// Source: [Swift Evolution proposal SE-0258](https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md#proposed-solution)
@propertyWrapper
public enum Lazy<Value> {
  case uninitialized(() -> Value)
  case initialized(Value)
  
  /// Creates the lazy value without initializing it.
  /// - Parameter initialValue: The initializer function that's used to initialize the value on first access.
  public init(initialValue: @autoclosure @escaping () -> Value) {
    self = .uninitialized(initialValue)
  }
  
  public var wrappedValue: Value {
    mutating get {
      switch self {
      case .uninitialized(let initializer):
        let value = initializer()
        self = .initialized(value)
        return value
      case .initialized(let value):
        return value
      }
    }
    set {
      self = .initialized(newValue)
    }
  }
}
