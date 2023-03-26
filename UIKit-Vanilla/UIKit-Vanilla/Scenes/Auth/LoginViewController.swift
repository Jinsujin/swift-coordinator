import UIKit

class LoginViewController: UIViewController {
    var onLogin: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginItem = UIBarButtonItem(title: "로그인", style: .plain, target: self, action: #selector(loginButtonDidTap))
        self.navigationItem.rightBarButtonItem = loginItem
        
        self.view.addSubview(titleLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleLabel.frame = view.bounds
    }
    
    deinit {
        print("❌ deinit:: \(type(of: self))")
    }
    
    
    @objc func loginButtonDidTap() {
        self.onLogin?()
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인 화면"
        label.textAlignment = .center
        return label
    }()
}
