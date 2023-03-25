import UIKit

final class SettingsViewController: UIViewController {
    
    var confirmed: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settingButtonItem = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(touchedConfirmButton))
        self.navigationItem.rightBarButtonItem = settingButtonItem
    }
    
    deinit {
        print("❌ deinit:: \(type(of: self))")
    }
    
    @objc func touchedConfirmButton() {
        self.confirmed?()
    }
}
