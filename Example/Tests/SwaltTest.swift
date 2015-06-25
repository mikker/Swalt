import XCTest
import Dispatcher
import Swalt

class SwaltTest: XCTestCase {
    
    var swalt: Swalt!
    
    override func setUp() {
        swalt = Swalt()
    }
    
    func testSwaltDispatch() {
        let dispatcher = swalt.dispatcher!
        XCTAssertNotNil(dispatcher)
        
        let payload: [String: Any] = ["test": 1]
        
        func callback(payload: Any?) {
            let message = payload as! (action: String, payload: Any?)
            let payload = message.payload as! [String: Int]
            XCTAssertEqual(message.action, "MY_ACTION")
            XCTAssertEqual(payload["test"]!, 1)
        }
        dispatcher.register(callback)
        
        swalt.dispatch("MY_ACTION", payload: ["test": 1])
    }
    
    func testSwaltBindAction() {
        let action = "MY_ACTIION"

        func callback(payload: Any?) {
            let payload = payload as! [String: Int]
            XCTAssertEqual(payload["test"]!, 1)
        }
        swalt.bindAction(action, handler: callback)
        
        let payload: [String: Int] = ["test": 1]
        swalt.dispatch(action, payload: payload)
    }
}