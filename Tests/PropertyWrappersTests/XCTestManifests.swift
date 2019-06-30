#if !canImport(ObjectiveC)
import XCTest

extension LazyTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__LazyTests = [
        ("testLazyCallsInitializerLazily", testLazyCallsInitializerLazily),
        ("testLazyDoesntCallInitializerWhenSetterIsInvokedFirst", testLazyDoesntCallInitializerWhenSetterIsInvokedFirst),
        ("testLazyInitializesValue", testLazyInitializesValue),
    ]
}

extension UserDefaultsTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__UserDefaultsTests = [
        ("testArray", testArray),
        ("testArrayOfCustomTypes", testArrayOfCustomTypes),
        ("testAssignmentSetsUserDefault", testAssignmentSetsUserDefault),
        ("testCustomType", testCustomType),
        ("testDictionary", testDictionary),
        ("testGetterRetrievesUserDefault", testGetterRetrievesUserDefault),
        ("testReturnsValueStoredInUserDefaults", testReturnsValueStoredInUserDefaults),
        ("testSetterIsNonmutating", testSetterIsNonmutating),
        ("testUsesDefaultValueIfNotSet", testUsesDefaultValueIfNotSet),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(LazyTests.__allTests__LazyTests),
        testCase(UserDefaultsTests.__allTests__UserDefaultsTests),
    ]
}
#endif
