import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let window = UIWindow(windowScene: windowScene)

        let navigationController = UINavigationController(
            rootViewController: ViewController()
        )
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window

        // [COMMENT] Coordinator & DI Container:
        // 1. Coordinater 가 있다면, navigationController 및 DIcontainer 주입 -> .start
        // 2. 없다면, DIContainer 만, Client Coordinator 에 주입 및 전달
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
