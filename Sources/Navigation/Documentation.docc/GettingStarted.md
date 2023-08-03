# Getting started with Navigation framework

Screen transitions using Navigation framework

## Overview

The Navigation framework mainly handles screen transitions, including alert dialog and launch other application.
This framework takes FlowController as its basic concept and provides practical practices of FlowController.

This framework core is ``FlowController`` protocol. Each Flows conform to this protocol.

The three flows which is used mainly are ``ApplicationFlow``, ``TabFlow``, and ``AnyFlow``.

``ApplicationFlow`` handles transitions for the entire application.
Transitions from push notifications and deepLink such as universal links is handled.

``TabFlow`` handle UITabBarController transition.

``AnyFlow`` handle mainly UINavigationController transition.
A FlowChild must be defined for each AnyFlow.
Each FlowChild corresponds to a screen, and each screen must belongs to one of the Flows.


@TabNavigator {
   @Tab("ApplicationFlow") {
       ```swift
       final class AppFlow: ApplicationFlow {
           private let mainFlow = MainFlow()

           private let loginFlow = LoginFlow(
               navigation: .init(),
               root: .login,
               from: AppFlow.self
           )

           init() {
               super.init(flows: [self.mainFlow, self.loginFlow])
           }

           required init(
               navigation: Never,
               root: ApplicationFlow.Child,
               from: any FlowController.Type,
               present: Bool,
               alertMessageAlignment: NSTextAlignment?,
               alertTintColor: UIColor?
           ) {
               fatalError("has not been implemented")
           }

           override func viewDidLoad() {
               super.viewDidLoad()
               self.start()
           }

           override func start() {
               super.start()
               add(self.loginFlow)
           }
       }
       ```
   }


   @Tab("TabFlow") {
       ```swift
       final class MainFlow: TabFlow {
           private let basicFlow = BasicFlow(
               navigation: .init(),
               root: .first,
               from: MainFlow.self
           )

           private let sampleFlow = SampleFlow(
               navigation: .init(),
               root: .collection,
               from: MainFlow.self
           )

           init() {
               let flows: [any FlowController] = [self.baseFlow, self.sampleFlow]

               super.init(
                   navigation: UITabBarController(),
                   from: AppFlow.self,
                   alertMessageAlignment: nil,
                   alertTintColor: nil,
                   flows: flows
               )
           }

           required init(
               navigation: TabBarController,
               root: TabFlow.Child,
               from: any FlowController.Type,
               present: Bool,
               alertMessageAlignment: NSTextAlignment?,
               alertTintColor: UIColor?
           ) {
               fatalError("has not been implemented")
           }
       }

       ```
   }

   
   

   @Tab("AnyFlow") {

       ```swift
       enum LoginFlowChild {
           case login
       }

       final class LoginFlow: AnyFlow<BaseFlow<LoginFlowChild>> {
           override var childProvider: (LoginFlowChild) -> UIViewController {{ [weak self] child in
               guard let self else { return .init(nibName: nil, bundle: nil) }

               switch child {
               case .login:
                   let vc = LoginViewController()
                   vc.inject(viewModel: .init(), ui: .init())
                   return vc
               }
           }}
       }
       ```

   }
}

AppDelegate has ApplicationFlow like below.

```swift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private let appFlowController: AppFlow = .init()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = self.appFlowController
        self.window?.makeKeyAndVisible()

        return true
    }
}
```

There are two types of screen transitions using Flow, `start` and `show`.
- `start` is used to create another Flow from a Flow.

```swift
self.start(
    flowType: CartFlow.self,
    root: .list,
    delegate: self,
    showType: .modal(navigation: .init(showCloseButton: true))
)
```


- `show` is used for transitions between FlowChilds in a Flow.

```swift
self.show(.productDetail(productId: productId))
```

Flow receives events from FlowChild and processes transitions.
The main use is Delegate.

```swift
protocol LoginViewControllerDelegate: AnyObject {
    func didNextButtonTapped()
}

final class LoginFlow: AnyFlow<BaseFlow<LoginFlowChild>> {
    override var childProvider: (LoginFlowChild) -> UIViewController {{ [weak self] child in
        guard let self else { return .init(nibName: nil, bundle: nil) }

        switch child {
        case .login:
            let vc = LoginViewController()
            vc.inject(viewModel: .init(), ui: .init())
            vc.delegate = self
            return vc
        }
    }}
}

extension LoginFlow: LoginViewControllerDelegate {
    func didNextButtonTapped() {
        self.show(.first)
    }
}
```
