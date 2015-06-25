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
```

## Todo

- [ ] Tests!
- [ ] Less class-y, more protocol-y
- [ ] Bundle everything up in shared Swaft instance (no singletons)
- [ ] Snapshots (easily serialize and restore **all** state)
- [ ] `state!["count"]!!` looks silly. Maybe structs for state?
- [ ] `let action = "ACTION"` is unhandy. Actual enums maybe?

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
