//import Cocoa
//
//// --Dispatcher
//let prefix = "ID_"
//var lastId = 1
//public class Dispatcher {
//    public static let instance = Dispatcher()
//    
//    var callbacks: [String: (Any?) -> Void] = [:]
//    var isPending: [String: (Bool)] = [:]
//    var isHandled: [String: (Bool)] = [:]
//    var isDispatching: Bool = false
//    var pendingPayload: Any?
//    
//    public init() {}
//    
//    // Public
//    
//    public func register(callback: (payload: Any?) -> Void) -> String {
//        let id = "\(prefix)\(lastId++)"
//        callbacks[id] = (callback)
//        return id
//    }
//    
//    public func unregister(id: String) {
//        if !callbacks.keys.contains(id) {
//            debugPrint("Dispatcher.unregister(...): `\(id)` does not map to a registered callback.")
//        }
//        callbacks.removeValueForKey(id)
//    }
//    
//    public func waitFor(ids: [String]) {
//        if !isDispatching {
//            debugPrint("Dispatcher.waitFor(...): Must be invoked while dispatching.")
//        }
//        for id in ids {
//            if (isPending[id]!) {
//                if !isHandled[id]! {
//                    debugPrint("Dispatcher.waitFor(...): Circular dependency detected while waiting for `\(id)`.")
//                }
//                continue
//            }
//            invokeCallback(id)
//        }
//    }
//    
//    public func dispatch(payload: Any?) {
//        if isDispatching {
//            debugPrint("Dispatch.dispatch(...): Cannot dispatch in the middle of a dispatch.")
//        }
//        startDispatching(payload)
//        defer { stopDispatching() }
//        for id in callbacks.keys {
//            if isPending[id]! {
//                continue
//            }
//            invokeCallback(id)
//        }
//    }
//    
//    // Private
//    
//    private func invokeCallback(id: String) {
//        isPending[id] = true
//        callbacks[id]!(pendingPayload)
//        isHandled[id] = true
//    }
//    
//    private func startDispatching(payload: Any?) {
//        for id in callbacks.keys {
//            isPending[id] = false
//            isHandled[id] = false
//        }
//        pendingPayload = payload
//        isDispatching = true
//    }
//    
//    private func stopDispatching() {
//        pendingPayload = nil
//        isDispatching = false
//    }
//}
//// --Dispatcher
//
//public class Swalt {
//    public static let instance = Swalt()
//    
//    public let dispatcher = Dispatcher()
//    public var stores: [SwaltStore] = []
//    private var token: String!
//    private var actions: [String: (Any?) -> Void] = [:]
//    
//    public init() {
//        token = dispatcher.register(handleDispatch)
//    }
//    
//    deinit {
//        dispatcher.unregister(token)
//    }
//    
//    public func dispatch(action: String, payload: Any?) {
//        let message = (action, payload) as Any
//        dispatcher.dispatch(message)
//    }
//    
//    public func bindAction(action: String, handler: (Any?) -> Void) {
//        actions[action] = handler
//    }
//
//    private func handleDispatch(message: Any?) {
//        let message = message as! (action: String, payload: Any?)
//        for (action, handler) in actions {
//            if action == message.action {
//                handler(message.payload)
//            }
//        }
//    }
//}
//
//public class SwaltStore {
//    var swalt: Swalt!
//    var dispatchToken: String!
//    var actions: [String: (Any?) -> ()] = [:]
//    
//    init(swalt: Swalt) {
//        self.swalt = swalt
//        
//        dispatchToken = swalt.dispatcher.register(handleDispatch)
//    }
//    
//    deinit {
//        swalt.dispatcher.unregister(dispatchToken)
//    }
//    
//    private func bindAction(action: String, handler: (Any?) -> Void) {
//        actions[action] = handler
//    }
//    
//    private func handleDispatch(message: Any?) {
//        let message = message as! (action: String, payload: Any?)
//        for (action, handler) in actions {
//            if action == message.action {
//                handler(message.payload)
//            }
//        }
//    }
//}
//
//struct MyActions {
//    static let Update = "MY_ACTIONS_UPDATE"
//}
//
//public class ThingsStore : SwaltStore {
//    var things: [Int] = []
//    
//    override init(swalt: Swalt) {
//        super.init(swalt: swalt)
//        
//        bindAction(MyActions.Update) { payload in
//            let payload = payload as! [String: [Int]]
//            self.things = payload["things"]!
//        }
//    }
//}
//
//let store = ThingsStore(swalt: Swalt.instance)
//
//Swalt.instance.bindAction(MyActions.Update) { payload in
//    debugPrint(payload!)
//}
//
//Swalt.instance.dispatch(MyActions.Update, payload: ["things": [1]])
