import UIKit

/// 로그인 했을떄의 흐름 제어
class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    // MARK: - Coordinator end event
    var finishFlow: (() -> Void)?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = MainViewController()
        viewController.view.backgroundColor = .systemGray3
        viewController.logout = { [unowned self] in
            self.finishFlow?()
        }
        viewController.setting = { [unowned self, unowned viewController] in
            self.showSetting(viewController)
        }
        self.navigationController.viewControllers = [viewController]
    }
    
    private func showSetting(_ vc: MainViewController) {
        let coordinator = SettingsCoordinator(navigationController: self.navigationController)
        coordinator.finishFlow = { [unowned self, unowned coordinator, weak vc] in
            // 설정이 끝나면 main view controller 로 이동
            self.removeDependency(coordinator)
            popTo(where: vc, animated: false)
        }
        self.addDependency(coordinator)
        coordinator.start()
    }
    
    func popTo(where vc: UIViewController?, animated: Bool) {
        guard let targetVC = vc else {
            return
        }
        for viewController in self.navigationController.viewControllers {
            if viewController == targetVC {
                self.navigationController.popToViewController(viewController, animated: animated)
                break
            }
        }
    }
}
