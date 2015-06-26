import XCTest
import Dispatcher
import Swalt

class StoreTest: XCTestCase {
    
    var swalt: Swalt!
    var store: Store!
    
    class MyStore: Store {
        override init() {
            super.init()
            
            bindAction("INCREMENT") { _ in
                let current = self.state!["count"]! as! Int
                self.state = ["count": current + 1]
            }
        }
        override func initialState() -> [String : Any?] {
            return ["count": 0]
        }
    }
    
    override func setUp() {
        swalt = Swalt.instance
        store = MyStore()
    }
    
    func testIncrementState() {
        swalt.dispatch("INCREMENT", payload: nil)
        XCTAssertEqual(store.state!["count"] as! Int, 1)
        
        swalt.dispatch("INCREMENT", payload: nil)
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
            func callback(state: [String: Any?]?) {
                count = state!["count"] as! Int
            }
            func unlisten() {
                store.unlisten(subscriptionId)
            }
        }
        
        let listener = Listener(store: store)
        XCTAssertNotNil(listener.subscriptionId)
        
        swalt.dispatch("INCREMENT", payload: nil)
        XCTAssertEqual(listener.count, 1)

        listener.unlisten()
        swalt.dispatch("INCREMENT", payload: nil)
        XCTAssertEqual(listener.count, 1)
    }
}