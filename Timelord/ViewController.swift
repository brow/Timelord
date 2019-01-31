import UIKit
import ReactiveCocoa

class ViewController: UIViewController {
    init(enableNotifications: @escaping () -> ()) {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        
        let button = UIButton(type: .system)
        button.setTitle(
            "Allow Notifications",
            for: .normal)
        
        let stackView = UIStackView(
            arrangedSubviews: [button])
        stackView.axis = .vertical
        stackView.alignment = .leading
        view.addSubview(stackView)
        
        // Layout
        
        let marginsGuide = view.layoutMarginsGuide
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor
            .constraint(equalTo: marginsGuide.topAnchor)
            .isActive = true
        stackView.leadingAnchor
            .constraint(equalTo: marginsGuide.leadingAnchor)
            .isActive = true
        stackView.trailingAnchor
            .constraint(lessThanOrEqualTo: marginsGuide.trailingAnchor)
            .isActive = true
        
        // Bindings
        
        button.reactive
            .controlEvents(.touchUpInside)
            .map { _ in }
            .observeValues(enableNotifications)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
