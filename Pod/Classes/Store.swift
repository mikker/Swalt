import Dispatcher

public class Store : Receiver {
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
        
        self.state = self.initialState()
    }
    
    public func initialState() -> [String: Any?] {
        return [:]
    }
    
    public func listen(callback: Any? -> Void) -> String {
        if let id = swalt.dispatcher.tokenGenerator.next() {
            let handler = Handler(callback)
            listeners[id] = handler
            handler.call(state) // send current state right away
            return id
        }
        
        preconditionFailure("\(object_getClass(self)).listen: Failed to generate token.")
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