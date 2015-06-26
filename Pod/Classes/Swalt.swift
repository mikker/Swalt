import Dispatcher

public class Swalt: Receiver {
    public static let instance = Swalt()
    var stores: [String: Store] = [:]
    
    public override init() {
        super.init()
        dispatcher = Dispatcher.instance
        register()
    }
    
    public func dispatch(action: Action, payload: Any?) {
        dispatch(action.name, payload: payload)
    }
    
    public func dispatch(action: String, payload: Any?) {
        let message = (action, payload) as Any?
        dispatcher.dispatch(message)
    }
    
    public func addStore(type: Store.Type) {
        let key = String(type)
        if self.stores.keys.contains(key) {
            preconditionFailure("Store of type \(key) already exists")
        }
        debugPrint(key)
        self.stores[key] = type.init(self)
    }
    
    public func getStore(type: Store.Type) -> Store {
        let key = String(type)
        if let store = stores[key] {
            return store
        } else {
            preconditionFailure("No store of type \(type)")
        }
    }
    

}