import UIKit
import Swalt

struct Actions {
    static let Increment = "INCREMENT"
}

class ClicksStore: SwaltStore {
    static let instance = ClicksStore()
    
    override init() {
        super.init()
        
        bindAction(Actions.Increment) { payload in
            let current = self.state!["count"]! as! Int
            self.state = ["count": current + 1]
        }
    }
    
    override func initialState() -> [String: Any?] {
        return ["count": 0]
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ClicksStore.instance.listen { state in
            let count = state!["count"]!!
            self.countLabel.text = String(count)
        }
    }

    @IBAction func doIt() {
        Swalt.instance.dispatch(Actions.Increment, payload: nil)
    }
}