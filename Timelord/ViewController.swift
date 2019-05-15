import UIKit
import ReactiveCocoa

final class ViewController: UIViewController {
    init(enableNotifications: @escaping () -> ()) {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 36)
        titleLabel.text = "Timelord"
        
        let bodyLabel = UILabel()
        bodyLabel.font = .systemFont(ofSize: 17)
        bodyLabel.numberOfLines = 0
        bodyLabel.text = "Set timers without touching or unlocking your phone, using Siri."
        
        let separatorLabel = UILabel()
        separatorLabel.font = .systemFont(ofSize: 17)
        separatorLabel.textColor = .gray
        separatorLabel.text = "﹡ ﹡ ﹡"
        
        let notificationsLabel = UILabel()
        notificationsLabel.font = .systemFont(ofSize: 17)
        notificationsLabel.numberOfLines = 0
        notificationsLabel.text = "To get started, allow the app to sound an alarm when one of your timers finishes:"
        
        let notificationsButton = RoundedRectButton()
        notificationsButton.titleLabel?.font = .boldSystemFont(ofSize: 19)
        notificationsButton.setTitle(
            "Allow Notifications",
            for: .normal)
        
        let spacing: CGFloat = 20
        
        let promptStackView = UIStackView(
            arrangedSubviews: [
                separatorLabel,
                notificationsLabel,
                notificationsButton,
            ])
        promptStackView.axis = .vertical
        promptStackView.spacing = spacing
        promptStackView.alignment = .leading
        
        let stackView = UIStackView(
            arrangedSubviews: [
                titleLabel,
                bodyLabel,
                promptStackView,
            ])
        stackView.axis = .vertical
        stackView.spacing = spacing
        view.addSubview(stackView)
        
        // Layout
        
        let marginsGuide = view.layoutMarginsGuide
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor
            .constraint(equalTo: marginsGuide.topAnchor, constant: 20)
            .isActive = true
        stackView.leadingAnchor
            .constraint(equalTo: marginsGuide.leadingAnchor)
            .isActive = true
        stackView.trailingAnchor
            .constraint(lessThanOrEqualTo: marginsGuide.trailingAnchor)
            .isActive = true
        
        // Bindings
        
        notificationsButton.reactive
            .controlEvents(.touchUpInside)
            .map { _ in }
            .observeValues(enableNotifications)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
