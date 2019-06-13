import UIKit

final class InstructionsCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        separatorInset.left = .greatestFiniteMagnitude
        
        let header = UILabel()
        header.font = .boldSystemFont(ofSize: 19)
        header.numberOfLines = 0
        header.text = "You can ask Siri…"
        
        func suggestion(_ text: String) -> UIView {
            let label = UILabel()
            label.font = .systemFont(ofSize: 17)
            label.textColor = .white
            label.numberOfLines = 0
            label.text = "\"\(text)\""
            
            let container = UIView()
            container.backgroundColor = .brand
            container.layer.cornerRadius = 12
            container.addSubview(label)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor
                .constraint(equalTo: container.leadingAnchor, constant: 14)
                .isActive = true
            label.trailingAnchor
                .constraint(equalTo: container.trailingAnchor, constant: -14)
                .isActive = true
            label.topAnchor
                .constraint(equalTo: container.topAnchor, constant: 10)
                .isActive = true
            label.bottomAnchor
                .constraint(equalTo: container.bottomAnchor, constant: -10)
                .isActive = true
            return container
        }
        
        let stackView = UIStackView(arrangedSubviews: [
            header,
            suggestion("In Timelord remind me in 20 minutes to take yams out"),
            suggestion("Show Timelord reminders"),
            ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        contentView.addSubview(stackView)
        
        // Layout
        
        let marginsGuide = contentView.layoutMarginsGuide
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor
            .constraint(equalTo: marginsGuide.topAnchor, constant: 6)
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
