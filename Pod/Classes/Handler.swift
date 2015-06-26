struct Handler {
    let call: Any? -> Void
    init(_ handler: Any? -> Void) {
        self.call = handler
    }
}