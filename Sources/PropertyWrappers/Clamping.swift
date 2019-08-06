/// A property wrapper that clamps a `Comparable` value to the specified closed range.
///
/// Sources:
/// - [Swift Evolution proposal SE-0258](https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md#clamping-a-value-within-bounds)
/// - Mattt Thompson, [NSHipster: Swift Property Wrappers](https://nshipster.com/propertywrapper/)
@propertyWrapper
public struct Clamping<Value: Comparable> {
  private var _wrappedValue: Value
  public let range: ClosedRange<Value>

  /// Initializes a clamped value.
  ///
  /// - Parameter initialValue: The initial value for `wrappedValue`. Must be inside `range`.
  /// - Parameter range: The range of allowed values for `wrappedValue`.
  ///
  /// The initializer traps if you pass an initialValue that is not inside the range.
  public init(wrappedValue: Value, range: ClosedRange<Value>) {
    precondition(range.contains(wrappedValue), "wrappedValue '\(wrappedValue)' must be inside the range '\(range)'")
    self._wrappedValue = wrappedValue
    self.range = range
  }

  public var wrappedValue: Value {
    get { _wrappedValue }
    set { _wrappedValue = min(max(range.lowerBound, newValue), range.upperBound) }
  }
}
