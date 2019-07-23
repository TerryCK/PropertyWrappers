#if !canImport(ObjectiveC)
import XCTest

extension DelayedInitTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__DelayedInitTests = [
        ("testDelayedLetInitializesOnSet", testDelayedLetInitializesOnSet),
        ("testDelayedVarInitializesOnSet", testDelayedVarInitializesOnSet),
        ("testDelayedVarResetReleasesValue", testDelayedVarResetReleasesValue),
    ]
}

extension LazyTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__LazyTests = [
        ("testLazyCallsInitializerLazily", testLazyCallsInitializerLazily),
        ("testLazyInitializesValue", testLazyInitializesValue),
    ]
}

extension RefTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__RefTests = [
        ("testDrillDownIntoRef", testDrillDownIntoRef),
        ("testRefReadsCapturedValue", testRefReadsCapturedValue),
        ("testRefWritesCapturedValue", testRefWritesCapturedValue),
        ("testTwoRefsShareSameVariable", testTwoRefsShareSameVariable),
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
        testCase(BoxTests.__allTests__BoxTests),
        testCase(DelayedInitTests.__allTests__DelayedInitTests),
        testCase(LazyTests.__allTests__LazyTests),
        testCase(RefTests.__allTests__RefTests),
        testCase(UserDefaultsTests.__allTests__UserDefaultsTests),
    ]
}
#endif
