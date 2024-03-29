import UIKit
import ReactiveSwift

final class HeaderCell: UITableViewCell {
    var showsSeparator = MutableProperty<Property<Bool>?>(nil)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 36)
        titleLabel.text = "Timelord"
        
        let bodyLabel = UILabel()
        bodyLabel.font = .systemFont(ofSize: 17)
        bodyLabel.numberOfLines = 0
        bodyLabel.text = "Set timers without touching or unlocking your phone, using your voice."
        
        let stackView = UIStackView(
            arrangedSubviews: [
                titleLabel,
                bodyLabel,
            ])
        stackView.axis = .vertical
        stackView.spacing = 14
        contentView.addSubview(stackView)
        
        // Layout
        
        let marginsGuide = contentView.layoutMarginsGuide
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor
            .constraint(
                equalTo: marginsGuide.topAnchor,
                constant: 20)
            .isActive = true
        stackView.bottomAnchor
            .constraint(
                equalTo: marginsGuide.bottomAnchor,
                constant: -8)
            .isActive = true
        stackView.leadingAnchor
            .constraint(equalTo: marginsGuide.leadingAnchor)
            .isActive = true
        stackView.trailingAnchor
            .constraint(equalTo: marginsGuide.trailingAnchor)
            .isActive = true
        
        // Bindings
        
        let defaultLeftSeparatorInset = separatorInset.left
        showsSeparator
            .flatMap(.latest) { $0 ?? .init(value: false) }
            .skipRepeats()
            .producer
            .startWithValues { [weak self] showsSeparator in
                self?.separatorInset.left = showsSeparator
                    ? defaultLeftSeparatorInset
                    : .greatestFiniteMagnitude
            }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
