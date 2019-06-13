import UIKit

final class NotificationsCell: UITableViewCell {
    var enableNotifications: (() -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        separatorInset.left = .greatestFiniteMagnitude
        
        let header = UILabel()
        header.font = .boldSystemFont(ofSize: 19)
        header.numberOfLines = 0
        header.text = "To get started…"
        
        let notificationsLabel = UILabel()
        notificationsLabel.font = .systemFont(ofSize: 17)
        notificationsLabel.numberOfLines = 0
        notificationsLabel.text = "Allow the app to sound an alarm when one of your timers finishes:"
        
        let notificationsButton = RoundedRectButton()
        notificationsButton.titleLabel?.font = .boldSystemFont(ofSize: 19)
        notificationsButton.setTitle(
            "Allow Notifications",
            for: .normal)
        
        let stackView = UIStackView(
            arrangedSubviews: [
                header,
                notificationsLabel,
                notificationsButton,
            ])
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.setCustomSpacing(20, after: notificationsLabel)
        stackView.alignment = .leading
        contentView.addSubview(stackView)
        
        // Layout
        
        let marginsGuide = contentView.layoutMarginsGuide
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor
            .constraint(equalTo: marginsGuide.topAnchor, constant: 8)
            .isActive = true
        stackView.bottomAnchor
            .constraint(equalTo: marginsGuide.bottomAnchor)
            .isActive = true
        stackView.leadingAnchor
            .constraint(equalTo: marginsGuide.leadingAnchor)
            .isActive = true
        stackView.trailingAnchor
            .constraint(equalTo: marginsGuide.trailingAnchor)
            .isActive = true
        
        // Bindings
        
        notificationsButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { [weak self] _ in self?.enableNotifications?() }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
