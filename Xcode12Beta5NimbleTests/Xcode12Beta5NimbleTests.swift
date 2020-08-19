import Foundation
import Nimble
import Quick
@testable import Xcode12Beta5Nimble

final class Xcode12Beta5NimbleTests: QuickSpec {
    override func spec() {
        describe("Model+Decodable") {
            var data: Data!
            context("when the data is invalid") {
                beforeEach {
                    data = "{\"wrong\": \"data\"}".data(using: .utf8)
                }

                it("should throw an error") {
                    // This should compile but doesn’t with Xcode 12 beta 5.
                    // There’s a “Ambiguous use of 'expect'” error, finding the two overloads:
                    // - public func expect<T>(_ expression: @autoclosure @escaping () throws -> T?, file: FileString = #file, line: UInt = #line) -> Expectation<T>
                    // - public func expect<T>(_ file: FileString = #file, line: UInt = #line, expression: @escaping () throws -> T?) -> Expectation<T>
                    expect {
                        try JSONDecoder().decode(Model.self, from: data)
                    }.to(throwError())
                }

                it("should throw an error") {
                    // Same as above but now with an additional hint for the compiler:
                    expect(expression: {
                        try JSONDecoder().decode(Model.self, from: data)
                    }).to(throwError())
                }
            }
        }
    }
}
