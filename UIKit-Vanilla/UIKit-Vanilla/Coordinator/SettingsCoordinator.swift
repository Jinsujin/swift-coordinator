import UIKit


/// 설정화면 흐름 제어
class SettingsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    // MARK: - Coordinator end event
    var finishFlow: (() -> Void)?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = SettingsViewController()
        viewController.view.backgroundColor = .systemGreen
        viewController.confirmed = { [unowned self] in
            self.finishFlow?()
        }
        // Navigation 으로 이전 화면(MainCoordinator)으로 이동하기 위해 Push 를 사용해 처음화면 설정
        // ❌ self.navigationController.viewControllers = [viewController]
        self.navigationController.pushViewController(viewController, animated: false)
        print("--------✅ [SettingsCoordinator] Started---------")
    }
}
