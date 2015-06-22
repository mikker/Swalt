import Dispatcher

public class Receiver {
    var dispatcher: Dispatcher!
    
    private var dispatchToken: String!
    private var actions: [String: (Any?) -> Void] = [:]
    
    init() {}
    
    deinit {
        dispatcher.unregister(dispatchToken)
    }
    
    func register()  {
        dispatchToken = self.dispatcher.register(handleDispatch)
    }
    
    public func bindAction(action: String, handler: (Any?) -> Void) {
        actions[action] = handler
    }
    
    func handleDispatch(message: Any?) {
        let message = message as! (action: String, payload: Any?)
        for (action, handler) in actions {
            if action == message.action {
                handler(message.payload)
            }
        }
    }
}