import XCTest
@testable import S4

class BodyTests: XCTestCase {
    static var allTests : [(String, (BodyTests) -> () throws -> Void)] {
        return [
           ("testBody", testBody),
        ]
    }

    let data: C7.Data = [0x00, 0x01, 0x02, 0x03]

    func testBody() {
        let body = Body.buffer(data)

        XCTAssert(body.isBuffer, "Body was not buffer")
    }

}
