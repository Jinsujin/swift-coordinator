import UIKit

final class RootCoordinator: NSObject, Coordinator {
    
    private var isAutorized = false
    
    // child coordinator의 인스턴스를 유지하기 위해 배열로 관리
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var finishFlow: (() -> Void)?
        
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() {
        if isAutorized {
            showMainViewController()
        } else {
            showLoginViewController()
        }
        navigationController.delegate = self
    }
    
    private func showMainViewController() {
        let coordinator = MainCoordinator(navigationController: self.navigationController)
        // 클로저가 실행했을때, self(Coordinator) 의 생명주기가 더 길기때문에 unowned 를 사용해도 된다
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeDependency(coordinator)
            self.isAutorized = false
            self.start()
        }
        self.addDependency(coordinator)
        coordinator.start()
    }
    
    private func showLoginViewController() {
        let coordinator = AuthCoordinator(navigationController: self.navigationController)
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeDependency(coordinator)
            self.isAutorized = true
            self.start()
        }
        self.addDependency(coordinator)
        coordinator.start()
    }
    
    func getRootViewController() -> UIViewController {
        return self.navigationController
    }
}

extension RootCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("🌠 didShow:: \(viewController)")
    }
}
