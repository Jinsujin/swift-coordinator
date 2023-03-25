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
}
