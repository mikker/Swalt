# Swalt

[![CI Status](http://img.shields.io/travis/mikker/Swalt.svg?style=flat)](https://travis-ci.org/mikker/Swalt)
[![Version](https://img.shields.io/cocoapods/v/Swalt.svg?style=flat)](http://cocoapods.org/pods/Swalt)
[![License](https://img.shields.io/cocoapods/l/Swalt.svg?style=flat)](http://cocoapods.org/pods/Swalt)
[![Platform](https://img.shields.io/cocoapods/p/Swalt.svg?style=flat)](http://cocoapods.org/pods/Swalt)

A minimal Flux implementation written in pure Swift 2. Inspired by [alt](https://github.com/goatslacker/alt).

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Example

```swift
import UIKit
import Swalt

struct CounterActions {
    static let Increment = Action("increment")
}

class ClicksStore: Store {
    override var initialState: State {
        return ["count": 0]
    }

    required init(_ swalt: Swalt) {
        super.init(swalt)

        bindAction(CounterActions.Increment) { _payload in
            let current = self.state["count"]! as! Int
            self.state = ["count": current + 1]
        }
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
            let count = state["count"] as! Int
            self.countLabel.text = String(count)
        }
    }

    @IBAction func doIt() {
        Swalt.instance.dispatch(CounterActions.Increment, payload: nil)
    }
}
```

## Todo

- [x] Snapshots (easily serialize and restore **all** state)
- [ ] Dictionaries are weird for states with all the typecasting.. Maybe structs instead?
- [ ] More examples

## Requirements

* [Dispatcher](https://github.com/mikker/Dispatcher)

## Installation

Swalt is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Swalt"
```

## Author

Mikkel Malmberg, mikkel@brnbw.com

## License

Swalt is available under the MIT license. See the LICENSE file for more info.
