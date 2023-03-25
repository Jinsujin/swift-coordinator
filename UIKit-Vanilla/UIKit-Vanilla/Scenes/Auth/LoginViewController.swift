import UIKit

class LoginViewController: UIViewController {
    var onLogin: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginItem = UIBarButtonItem(title: "로그인", style: .plain, target: self, action: #selector(loginButtonDidTap))
        self.navigationItem.rightBarButtonItem = loginItem
    }
    
    deinit {
        print("❌ deinit:: \(type(of: self))")
    }
    
    @objc func loginButtonDidTap() {
        self.onLogin?()
    }
}
