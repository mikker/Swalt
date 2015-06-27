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
    
    // Dispatch
    
    public func dispatch(action: Action, payload: Any?) {
        dispatch(action.name, payload: payload)
    }
    
    public func dispatch(action: String, payload: Any?) {
        let message = (action, payload) as Any?
        dispatcher.dispatch(message)
    }
    
    // Stores
    
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
    
    // Snapshots
    
    public func takeSnapshot() -> String {
        let initial: [StoreType: State] = [:]
        let snapshot = stores.reduce(initial, combine: { (var snapshot, elm) in
            snapshot[elm.0] = elm.1.state
            return snapshot
        })
        
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(snapshot, options: NSJSONWritingOptions())
            let string = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
            return string
        } catch {
            preconditionFailure("Failed to snapshot to JSON")
        }
    }
    
    public func bootstrap(snapshot: String) {
        do {
            let data = snapshot.dataUsingEncoding(NSUTF8StringEncoding)
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
            let snapshot = json as! [StoreType: State]
            for (key, state) in snapshot {
                if let store = stores[key] {
                    store.state = state
                }
            }
        } catch {
            preconditionFailure("Failed to bootstrap from snapshot: \(error)")
        }
    }
    
}