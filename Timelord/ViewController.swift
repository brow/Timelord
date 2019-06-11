import UIKit
import ReactiveSwift
import ReactiveCocoa

final class ViewController: UIViewController {
    init(
        notificationsAreEnabled: Property<Bool>,
        enableNotifications: @escaping () -> ())
    {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 36)
        titleLabel.text = "Timelord"
        
        let bodyLabel = UILabel()
        bodyLabel.font = .systemFont(ofSize: 17)
        bodyLabel.numberOfLines = 0
        bodyLabel.text = "Set timers without touching or unlocking your phone, using your voice."
        
        let notificationsView = makeNotificationsView(
            enableNotifications: enableNotifications)
        
        let instructionsView = makeInstructionsView()
        
        let stackView = UIStackView(
            arrangedSubviews: [
                titleLabel,
                bodyLabel,
                notificationsView,
                instructionsView,
            ])
        stackView.axis = .vertical
        stackView.spacing = 20
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
        
        notificationsView.reactive.isHidden <~ notificationsAreEnabled
        instructionsView.reactive.isHidden <~ notificationsAreEnabled.map(!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private func makeInstructionsView() -> UIView {
    let header = UILabel()
    header.font = .boldSystemFont(ofSize: 19)
    header.numberOfLines = 0
    header.text = "You can ask Siri…"
    
    let label = UILabel()
    label.font = .systemFont(ofSize: 17)
    label.numberOfLines = 0
    label.text = "• \"In Timelord remind me in 20 minutes to take yams out\"\n\n• \"Show Timelord reminders\""
    
    let stackView = UIStackView(arrangedSubviews: [
        header,
        label,
        ])
    stackView.axis = .vertical
    stackView.spacing = 10
    return stackView
}

private func makeNotificationsView(
    enableNotifications: @escaping () -> ())
    -> UIView
{
    let notificationsLabel = UILabel()
    notificationsLabel.font = .systemFont(ofSize: 17)
    notificationsLabel.numberOfLines = 0
    notificationsLabel.text = "To get started, allow the app to sound an alarm when one of your timers finishes:"
    
    let notificationsButton = RoundedRectButton()
    notificationsButton.titleLabel?.font = .boldSystemFont(ofSize: 19)
    notificationsButton.setTitle(
        "Allow Notifications",
        for: .normal)
    
    let stackView = UIStackView(
        arrangedSubviews: [
            notificationsLabel,
            notificationsButton,
        ])
    stackView.axis = .vertical
    stackView.spacing = 20
    stackView.alignment = .leading
    
    // Bindings
    
    notificationsButton.reactive
        .controlEvents(.touchUpInside)
        .map { _ in }
        .observeValues(enableNotifications)
    
    return stackView
}
