public struct Action: Hashable {
    let name: String
    
    public var hashValue: Int {
        get { return self.name.hashValue }
    }
    
    public init(_ name: String) {
        self.name = name
    }
}

public func ==(lhs: Action, rhs: Action) -> Bool {
    return lhs.name == rhs.name
}