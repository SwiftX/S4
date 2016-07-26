import Foundation
import XCTest

extension XCTestCase {
    class func series(tasks asyncTasks: [((Void) -> Void) -> Void], completion: (Void) -> Void) {
        var index = 0
        func _series(_ current: (((Void) -> Void) -> Void)) {
            current {
                index += 1
                index < asyncTasks.count ? _series(asyncTasks[index]) : completion()
            }
        }
        _series(asyncTasks[index])
    }
    
#if swift(>=3.0)
    func waitForExpectations(delay sec: TimeInterval = 1, withDescription: String, callback: ((Void) -> Void) -> Void) {
        let expectation = self.expectation(description: withDescription)

        let done = {
            expectation.fulfill()
        }
        
        callback(done)
        
        self.waitForExpectations(timeout: sec) {
            XCTAssertNil($0, "Timeout of \(Int(sec)) exceeded")
        }
    }
#else
    func waitForExpectations(delay sec: NSTimeInterval = 1, withDescription: String, callback: ((Void) -> Void) -> Void) {
        let expectation = self.expectationWithDescription(withDescription)

        let done = {
            expectation.fulfill()
        }
        
        callback(done)
        
        waitForExpectationsWithTimeout(sec) {
            XCTAssertNil($0, "Timeout of \(Int(sec)) exceeded")
        }
    }
#endif
}
