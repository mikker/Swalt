import Dispatcher

public class Store : Receiver {
    let prefix = "ID_"
    var lastId = 1
    
    let swalt: Swalt
    
    var listeners: [String: Handler] = [:]
    public var state: [String: Any?]? {
        didSet {
            self.notifyListeners()
        }
    }
    
    public required init(_ swalt: Swalt) {
        self.swalt = swalt

        super.init()
        
        dispatcher = swalt.dispatcher
        register()
        
        ({ self.state = self.initialState() })()
    }
    
    public func initialState() -> [String: Any?] {
        return [:]
    }
    
    public func listen(callback: Any? -> Void) -> String {
        let id = "\(prefix)\(lastId++)"
        let handler = Handler(callback)
        listeners[id] = handler
        handler.call(state) // send current state right away
        return id
    }

    public func unlisten(id: String) {
        listeners.removeValueForKey(id)
    }
    
    private func notifyListeners() {
        for (_, handler) in listeners {
            handler.call(self.state)
        }
    }
}