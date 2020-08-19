# Example project for a Swift/Nimble bug

Nimble bug report: https://github.com/Quick/Nimble/issues/809
Currently using Nimble 9.0.0-rc.1 and Quick 3.0.0, the problem also exists in Nimble 8.1.1.

To reproduce, just build for testing.

In essence the Swift compiler, starting with Xcode 12 beta 5, fails to compile code that uses the closure variant of `expect`. Using it results in an “ambiguous use of” error.

When all works as epxected this project and its tests should build cleanly. The two test methods should both compile and call the same method.
