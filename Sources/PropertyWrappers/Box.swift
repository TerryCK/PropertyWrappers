/// A property wrapper that boxes any value in a class to give it reference semantics.
///
/// Source: [Swift Evolution proposal SE-0258](https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md#ref--box)
@propertyWrapper
public class Box<Value> {
  public var wrappedValue: Value

  public init(initialValue: Value) {
    self.wrappedValue = initialValue
  }

  /// A `Ref` that can read and mutate `wrappedValue`.
  public var projectedValue: Ref<Value> {
    Ref(read: { self.wrappedValue }, write: { self.wrappedValue = $0 })
  }
}
