import UIKit

final class HeaderCell: UITableViewCell {
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
            .constraint(equalTo: marginsGuide.topAnchor)
            .isActive = true
        stackView.bottomAnchor
            .constraint(
                equalTo: marginsGuide.bottomAnchor,
                constant: -10)
            .isActive = true
        stackView.leadingAnchor
            .constraint(equalTo: marginsGuide.leadingAnchor)
            .isActive = true
        stackView.trailingAnchor
            .constraint(equalTo: marginsGuide.trailingAnchor)
            .isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
