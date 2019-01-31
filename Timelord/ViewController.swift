import UIKit
import ReactiveCocoa

class ViewController: UIViewController {
    init(enableNotifications: @escaping () -> ()) {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 36)
        titleLabel.text = "Timelord"
        
        let bodyLabel = UILabel()
        bodyLabel.font = .systemFont(ofSize: 15)
        bodyLabel.numberOfLines = 0
        bodyLabel.text = "This app lets you set timers without touching or unlocking your phone, using Siri.\n\n* * *\n\nTo get started, we need to allow Timelord to play an alarm sound when one of your timers finishes:"
        
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitle(
            "Allow Notifications",
            for: .normal)
        
        let stackView = UIStackView(
            arrangedSubviews: [
                titleLabel,
                bodyLabel,
                button,
                ])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
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
