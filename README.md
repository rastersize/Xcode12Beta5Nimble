# Example project for a Swiftc Xcode 12 beta 5 bug

Currently using Xcode 12 beta 5 with Nimble 9.0.0-rc.1 and Quick 3.0.0, the problem also exists in Nimble 8.1.1.

Related: Nimble bug report: https://github.com/Quick/Nimble/issues/809

**To reproduce:**

1. Run `carthage.sh bootstrap`
    - The script works around a Carthage bug with Xcode 12 beta 4+ and universal binaries. As newer versions of Xcode 12 will produce an `arm64` slice for both the simulator and device, and a universal binary can’t contain two slices for the same architecture.
2. Open the Xcode project
3. Build for testing.

In essence the Swift compiler, starting with Xcode 12 beta 5, fails to compile code that uses the closure variant of `expect`. Using it results in an “ambiguous use of” error. Specifically these two functions:
- `public func expect<T>(_ expression: @autoclosure @escaping () throws -> T?, file: FileString = #file, line: UInt = #line) -> Expectation<T>`
   - https://github.com/Quick/Nimble/blob/master/Sources/Nimble/DSL.swift?rgh-link-date=2020-08-19T18%3A02%3A48Z#L1-L8
- `public func expect<T>(_ file: FileString = #file, line: UInt = #line, expression: @escaping () throws -> T?) -> Expectation<T>`
   - https://github.com/Quick/Nimble/blob/master/Sources/Nimble/DSL.swift?rgh-link-date=2020-08-19T18%3A02%3A48Z#L10-L17

When all works as epxected this project and its tests should build cleanly. The two test methods should both compile and call the same method.
