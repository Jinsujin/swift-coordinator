import UIKit

final class SettingsViewController: UIViewController {
    
    var confirmed: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settingButtonItem = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(touchedConfirmButton))
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
    
    @objc func touchedConfirmButton() {
        self.confirmed?()
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "설정 화면(Main Coordinator 자식)"
        label.textAlignment = .center
        return label
    }()
}
