# Example project for a Swift/Nimble bug

Nimble bug report: https://github.com/Quick/Nimble/issues/809
Currently using Nimble 9.0.0-rc.1 and Quick 3.0.0, the problem also exists in Nimble 8.1.1.

**To reproduce:**

1. Run `carthage.sh bootstrap`
    - The script works around a Carthage bug with Xcode 12 beta 4+ and universal binaries. As newer versions of Xcode 12 will produce an `arm64` slice for both the simulator and device, and a universal binary can’t contain two slices for the same architecture.
2. Open the Xcode project
3. Build for testing.

In essence the Swift compiler, starting with Xcode 12 beta 5, fails to compile code that uses the closure variant of `expect`. Using it results in an “ambiguous use of” error.

When all works as epxected this project and its tests should build cleanly. The two test methods should both compile and call the same method.
