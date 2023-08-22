# Usage of respondor chain for transition

Usage of respondor chain for screen transition.

## Overview

you can use respondor chain fot screen transition.

### Definition

```swift
@MainActor
protocol SampleResponder: AnyObject {
    func execute(action: SampleAction)
}

struct SampleAction: Action {
    typealias Responder = SampleResponder

    enum ActionType {
        case showSample(id: Int)
    }

    let actionType: ActionType

    init(actionType: ActionType) {
        self.actionType = actionType
    }

    func execute(responder: any Responder) {
        responder.execute(action: self)
    }
}
```

```swift
extension SampleFlow: SampleResponder {
    func execute(action: SampleAction) {
        switch action.actionType {
            case let .showSample(id):
                self.show(.detail(id))
        }
    }
}
```

### Usage

```swift
self.execute(action: SampleAction(actionType: .showSample(id: 1)))
```
