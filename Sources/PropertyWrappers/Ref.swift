/// A property wrapper that encapsulates a getter and setter for a captured variable.
///
/// Can be used to create a "shared mutable struct": multiple `Ref` instances that
/// capture the same struct variable in their `read` and `write` closures will
/// mutate the common storage of the captured variable.
///
/// Difference between `Ref` and `Box`:
///
/// > `Box` is for creating storage, and `Ref` is about referring to something that's either
/// directly in a Box, formed through some other get/set pair (say, a computed value),
/// or derived via key path from another Ref thing.
/// > — https://forums.swift.org/t/se-0258-property-delegates/23139/99
///
/// Source: [Swift Evolution proposal SE-0258](https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md#ref--box)
@dynamicMemberLookup
@propertyWrapper
public struct Ref<Value> {
  /// The getter for reading the current value.
  private let read: () -> Value
  /// The setter for setting a new value.
  private let write: (Value) -> Void

  public init(read: @escaping () -> Value, write: @escaping (Value) -> Void) {
    self.read = read
    self.write = write
  }

  public var wrappedValue: Value {
    get { return read() }
    nonmutating set { write(newValue) }
  }

  /// A `Ref` that drills down into `wrappedValue` and provides a shared mutable
  /// view of the property specified by `keyPath`.
  public subscript<U>(dynamicMember keyPath: WritableKeyPath<Value, U>) -> Ref<U> {
    return Ref<U>(
      read: { self.wrappedValue[keyPath: keyPath] },
      write: { self.wrappedValue[keyPath: keyPath] = $0 })
  }
}
