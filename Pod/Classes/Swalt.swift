import Dispatcher

public class Swalt : Receiver {
    public static let instance = Swalt()

    public override init() {
        super.init()
        dispatcher = Dispatcher.instance
        register()
    }
    
    public func dispatch(action: Action, payload: Any?) {
        let message = (action, payload) as Any?
        dispatcher.dispatch(message)
    }
}