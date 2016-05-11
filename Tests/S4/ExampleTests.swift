import XCTest
@testable import S4

class ExampleTests: XCTestCase {
    static var allTests : [(String, (ExampleTests) -> () throws -> Void)] {
        return [
           ("testReality", testReality),
        ]
    }

	func testReality() {
		XCTAssert(2 + 2 == 4, "Something is severely wrong here.")
	}

}