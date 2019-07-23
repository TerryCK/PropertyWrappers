/// A reference type that can create an independent copy of itself.
public protocol Copyable: AnyObject {
  func copy() -> Self
}

/// A property wrapper that gives an object copy-on-write semantics.
///
/// Source: Brent Royal-Gordon, [Swift Evolution proposal SE-0258](https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md#copy-on-write)
@propertyWrapper
public struct CopyOnWrite<Value: Copyable> {
  private var _wrappedValue: Value

  public init(initialValue: Value) {
    _wrappedValue = initialValue
  }

  public var wrappedValue: Value {
    mutating get {
      if !isKnownUniquelyReferenced(&_wrappedValue) {
        _wrappedValue = _wrappedValue.copy()
      }
      return _wrappedValue
    }
    set {
      _wrappedValue = newValue
    }
  }
}
