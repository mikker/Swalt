import Dispatcher

public class Receiver {
    public var dispatcher: Dispatcher!
    
    private var dispatchToken: String?
    private var actions: [Action: Handler] = [:]
    
    init() {}
    
    deinit {
        if let token = dispatchToken {
            dispatcher.unregister(token)
        }
    }
    
    func register()  {
        dispatchToken = self.dispatcher.register(handleDispatch)
    }
    
    public func bindAction(action: Action, handler: Handler) {
        actions[action] = handler
    }
    
    func handleDispatch(message: Any?) {
        let message = message as! (action: String, payload: Any?)
        for (action, handler) in actions {
            if action.name == message.action {
                handler.call(message.payload)
            }
        }
    }
}