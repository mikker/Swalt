import XCTest
import Dispatcher
import Swalt

class SwaltTest: XCTestCase {
    
    var swalt: Swalt!
    let action = Action("MY_ACTION")
    
    override func setUp() {
        swalt = Swalt()
    }
    
    func testDispatch() {
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
        
        swalt.dispatch(action, payload: ["test": 1])
    }
    
    func testBindAction() {
        func callback(payload: Any?) {
            let payload = payload as! [String: Int]
            XCTAssertEqual(payload["test"]!, 1)
        }
        swalt.bindAction(action, callback: callback)
        
        let payload: [String: Int] = ["test": 1]
        swalt.dispatch(action, payload: payload)
    }
    
    func testSnapshot() {
        class CandyStore: Store {
            override var initialState: State {
                return [:]
            }
        }
        let store = swalt.addStore(CandyStore)
        store.state = ["numbers": 1]
        let snapshot = swalt.takeSnapshot()
        
        let newSwalt = Swalt()
        newSwalt.addStore(CandyStore)
        newSwalt.bootstrap(snapshot)
        let newStore = newSwalt.getStore(CandyStore)
        
        XCTAssertEqual(newStore.state["numbers"] as! Int, 1)
    }
}