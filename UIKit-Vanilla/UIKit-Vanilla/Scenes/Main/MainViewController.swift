import UIKit

class MainViewController: UIViewController {
    
    var logout: (() -> Void)?
    var setting: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logOutButtonItem = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: #selector(touchedLogoutButton))
        self.navigationItem.leftBarButtonItem = logOutButtonItem
        
        let settingButtonItem = UIBarButtonItem(title: "설정", style: .plain, target: self, action: #selector(touchedSettingButton))
        self.navigationItem.rightBarButtonItem = settingButtonItem
        
        self.view.addSubview(titleLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleLabel.frame = view.bounds
    }
    
    deinit {
        print("❌ deinit:: \(type(of: self))")
    }
    
    @objc func touchedLogoutButton() {
        self.logout?()
    }
    
    @objc func touchedSettingButton() {
        self.setting?()
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "메인 화면(로그인 되었다)"
        label.textAlignment = .center
        return label
    }()
}
