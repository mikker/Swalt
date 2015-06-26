import UIKit
import Swalt

struct CounterActions {
    static let Increment = Action("increment")
}

class ClicksStore: Store {
    required init(_ swalt: Swalt) {
        super.init(swalt)
        
        bindAction(CounterActions.Increment) { payload in
            let current = self.state!["count"]! as! Int
            self.state = ["count": current + 1]
        }
    }
    
    override func initialState() -> [String: Any?] {
        return ["count": 0]
    }
}

class Flux: Swalt {
    static let shared = Flux()
    
    override init() {
        super.init()
        addStore(ClicksStore)
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Flux.shared.getStore(ClicksStore).listen { state in
            let state = state as! [String: Any?]
            let count = state["count"] as! Int
            self.countLabel.text = String(count)
        }
    }

    @IBAction func doIt() {
        Swalt.instance.dispatch(CounterActions.Increment, payload: nil)
    }
}