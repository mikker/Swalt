import Dispatcher

let prefix = "ID_"
var lastId = 1

public class SwaltStore : Receiver {
    let swalt = Swalt.instance
    
    var listeners: [String: ([String: Any?]?) -> Void] = [:]
    public var state: [String: Any?]? {
        didSet {
            self.notifyListeners()
        }
    }
    
    public override init() {
        super.init()
        dispatcher = swalt.dispatcher
        register()
        
        ({ self.state = self.initialState() })()
    }
    
    public func initialState() -> [String: Any?] {
        return [:]
    }
    
    public func listen(handler: ([String: Any?]?) -> Void) -> String {
        let id = "\(prefix)\(lastId++)"
        listeners[id] = handler
        handler(state)
        return id
    }

    public func unlisten(id: String) {
        listeners.removeValueForKey(id)
    }
    
    private func notifyListeners() {
        for (_, handler) in listeners {
            handler(self.state)
        }
    }
}