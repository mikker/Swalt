import Dispatcher

public typealias State = [String: AnyObject]

public class Store : Receiver {
    let swalt: Swalt
    
    var listeners: [String: State -> Void] = [:]
    
    public var state: State {
        didSet {
            self.notifyListeners()
        }
    }
    
    public required init(_ swalt: Swalt) {
        self.swalt = swalt
        self.state = [:]

        super.init()
        
        dispatcher = swalt.dispatcher
        register()
        
        self.state = self.initialState
    }
    
    public var initialState: State {
        return [:]
    }
    
    public func listen(handler: State -> Void) -> String {
        if let id = swalt.dispatcher.tokenGenerator.next() {
            listeners[id] = handler
            handler(state) // send current state right away
            return id
        }
        
        preconditionFailure("\(object_getClass(self)).listen: Failed to generate token.")
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