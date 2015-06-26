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
    
    public func bindAction(action: Action, callback: Any? -> Void) {
        actions[action] = Handler(callback)
    }
    
    func handleDispatch(message: Any?) {
        let message = message as! (action: String, payload: Any?)
        let messageAction = Action(message.action)
        for (action, handler) in actions {
            if action == messageAction {
                handler.call(message.payload)
            }
        }
    }
}