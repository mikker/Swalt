import XCTest
import Dispatcher
import Swalt

let action = Action("INCREMENT")

class StoreTest: XCTestCase {
    
    var swalt: Swalt!
    var store: Store!
    
    class MyStore: Store {
        required init(_ swalt: Swalt) {
            super.init(swalt)
            
            bindAction(action) { _ in
                let current = self.state!["count"]! as! Int
                self.state = ["count": current + 1]
            }
        }
        override func initialState() -> [String : Any?] {
            return ["count": 0]
        }
    }
    
    override func setUp() {
        swalt = Swalt()
        swalt.addStore(MyStore)
        store = swalt.getStore(MyStore)
    }
    
    func testIncrementState() {
        swalt.dispatch(action, payload: nil)
        XCTAssertEqual(store.state!["count"] as! Int, 1)
        
        swalt.dispatch(action, payload: nil)
        XCTAssertEqual(store.state!["count"] as! Int, 2)
    }
    
    func testListen() {
        class Listener {
            var store: Store!
            var subscriptionId: String!
            var count: Int = 0
            init(store: Store) {
                self.store = store
                subscriptionId = store.listen(callback)
            }
            func callback(state: Any?) {
                let state = state as! [String: Any?]
                count = state["count"] as! Int
            }
            func unlisten() {
                store.unlisten(subscriptionId)
            }
        }
        
        let listener = Listener(store: store)
        XCTAssertNotNil(listener.subscriptionId)
        
        swalt.dispatch(action, payload: nil)
        XCTAssertEqual(listener.count, 1)

        listener.unlisten()
        swalt.dispatch(action, payload: nil)
        XCTAssertEqual(listener.count, 1)
    }
}