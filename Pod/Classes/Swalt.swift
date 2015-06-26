import Dispatcher

public typealias StoreType = String

public class Swalt: Receiver {
    public static let instance = Swalt()
    var stores: [StoreType: Store] = [:]
    
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
    
    public func addStore(type: Store.Type) -> Store {
        let key = StoreType(type)
        
        precondition(!self.stores.keys.contains(key), "Store of type \(key) already added")
        
        let store = type.init(self)
        self.stores[key] = store
        return store
    }
    
    public func getStore(type: Store.Type) -> Store {
        let key = StoreType(type)
        
        if let store = stores[key] {
            return store
        } else {
            preconditionFailure("No store of type \(type)")
        }
    }
    

}