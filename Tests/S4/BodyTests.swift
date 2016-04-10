import XCTest
@testable import S4

class BodyTests: XCTestCase {
    static var allTests : [(String, BodyTests -> () throws -> Void)] {
        return [
           ("testSender", testSender),
           ("testReceiver", testReceiver),
           ("testBuffer", testBuffer),
        ]
    }

    let data: Data = [0x00, 0x01, 0x02, 0x03]

    func testSender() {
        let sender = Body.sender { stream in
            try stream.send(self.data)
        }

        testBodyProperties(sender)
    }

    func testReceiver() {
        let drain = Drain(for: self.data)
        let receiver = Body.receiver(drain)

        testBodyProperties(receiver)
    }

    func testBuffer() {
        let buffer = Body.buffer(self.data)

        testBodyProperties(buffer)
    }

    private func testBodyProperties(body: Body) {
        var bodyForBuffer = body
        var bodyForReceiver = body
        var bodyForSender = body

        XCTAssert(data == (try! bodyForBuffer.becomeBuffer()), "Garbled buffer bytes")
        switch bodyForBuffer {
        case .buffer(let d):
            XCTAssert(data == d, "Garbled buffer bytes")
        default:
            XCTFail("Incorrect type")
        }

        bodyForReceiver.forceReopenDrain()
        let receiverDrain = Drain(for: try! bodyForReceiver.becomeReceiver())
        XCTAssert(data == receiverDrain.data, "Garbled receiver bytes")
        switch bodyForReceiver {
        case .receiver(let stream):
            bodyForReceiver.forceReopenDrain()
            let receiverDrain = Drain(for: stream)
            XCTAssert(data == receiverDrain.data, "Garbed receiver bytes")
        default:
            XCTFail("Incorrect type")
        }


        let senderDrain = Drain()
        bodyForReceiver.forceReopenDrain()
        do {
            try bodyForSender.becomeSender()(senderDrain)

        } catch {
            XCTFail("Drain threw error \(error)")
        }
        XCTAssert(data == senderDrain.data, "Garbled sender bytes")

        switch bodyForSender {
        case .sender(let closure):
            let senderDrain = Drain()
            bodyForReceiver.forceReopenDrain()
            do {
                try closure(senderDrain)
            } catch {
                XCTFail("Drain threw error \(error)")
            }
            XCTAssert(data == senderDrain.data, "Garbed sender bytes")
        default:
            XCTFail("Incorrect type")
        }
    }

}

extension Body {
    mutating func forceReopenDrain() {
        if let drain = (try! self.becomeReceiver()) as? Drain {
            drain.closed = false
        }
    }
}