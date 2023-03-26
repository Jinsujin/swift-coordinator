import UIKit

/// 로그인 하지 않았을때의 흐름 제어
class AuthCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    // MARK: - Coordinator end event
    var finishFlow: (() -> Void)?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = LoginViewController()
        viewController.view.backgroundColor = .systemOrange
        
        // 로그인되면 AuthCoordinator 의 종료를 알린다
        viewController.onLogin = { [unowned self] in
            self.finishFlow?()
        }
        self.navigationController.viewControllers = [viewController]
        print("--------✅ [AuthCoordinator] Started---------")
    }
}

