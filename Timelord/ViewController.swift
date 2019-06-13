import UIKit
import ReactiveSwift
import ReactiveCocoa
import ReactiveLists
import Core

final class ViewController: UITableViewController {
    init(
        notificationsAreEnabled: Property<Bool>,
        enableNotifications: @escaping () -> ())
    {
        super.init(style: .plain)
        
        tableView.rowHeight = ReminderCell.height
        tableView.tableFooterView = UIView()
        
        let tableViewModel = Property
            .combineLatest(
                persistedReminders,
                notificationsAreEnabled)
            .map { persistedReminders, notificationsAreEnabled -> TableViewModel in
                var rows = [Row.header]
                rows.append(
                    contentsOf: persistedReminders.map(Row.reminder))
                return TableViewModel(sectionModels: [
                    TableSectionViewModel(
                        diffingKey: "main",
                        cellViewModels: rows),
                ])
            }
        
        let driver = TableViewDriver(
            tableView: tableView,
            tableViewModel: tableViewModel.value)
        
        tableViewModel
            .producer
            .take(during: reactive.lifetime)
            .startWithValues { driver.tableViewModel = $0 }
        
//        let notificationsView = makeNotificationsView(
//            enableNotifications: enableNotifications)
//
//        let instructionsView = makeInstructionsView()
//
//        notificationsView.reactive.isHidden <~ notificationsAreEnabled
//        instructionsView.reactive.isHidden <~ notificationsAreEnabled.map(!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum Row: TableCellViewModel {
    case header
    case reminder(Reminder)
    
    public var registrationInfo: ViewRegistrationInfo {
        return ViewRegistrationInfo(classType: {
            switch self {
            case .header:
                return HeaderCell.self
            case .reminder:
                return ReminderCell.self
            }
        }())
    }
    
    public var accessibilityFormat: CellAccessibilityFormat {
        return ""
    }
    
    public var rowHeight: CGFloat? {
        switch self {
        case .header:
            return UITableView.automaticDimension
        case .reminder:
            return ReminderCell.height
        }
    }
    
    public func applyViewModelToCell(_ cell: UITableViewCell) {
        switch self {
        case .header:
            break
        case .reminder(let reminder):
            guard
                let cell = cell as? ReminderCell
                else { return }
            cell.model.value = reminder
        }
    }
}

//private func makeInstructionsView() -> UIView {
//    let header = UILabel()
//    header.font = .boldSystemFont(ofSize: 19)
//    header.numberOfLines = 0
//    header.text = "You can ask Siri…"
//    
//    func suggestion(_ text: String) -> UIView {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 17)
//        label.textColor = .white
//        label.numberOfLines = 0
//        label.text = "\"\(text)\""
//        
//        let container = UIView()
//        container.backgroundColor = .brand
//        container.layer.cornerRadius = 12
//        container.addSubview(label)
//        
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.leadingAnchor
//            .constraint(equalTo: container.leadingAnchor, constant: 14)
//            .isActive = true
//        label.trailingAnchor
//            .constraint(equalTo: container.trailingAnchor, constant: -14)
//            .isActive = true
//        label.topAnchor
//            .constraint(equalTo: container.topAnchor, constant: 10)
//            .isActive = true
//        label.bottomAnchor
//            .constraint(equalTo: container.bottomAnchor, constant: -10)
//            .isActive = true
//        return container
//    }
//        
//    let stackView = UIStackView(arrangedSubviews: [
//        header,
//        suggestion("In Timelord remind me in 20 minutes to take yams out"),
//        suggestion("Show Timelord reminders"),
//        ])
//    stackView.axis = .vertical
//    stackView.spacing = 16
//    stackView.alignment = .leading
//    return stackView
//}
//
//private func makeNotificationsView(
//    enableNotifications: @escaping () -> ())
//    -> UIView
//{
//    let header = UILabel()
//    header.font = .boldSystemFont(ofSize: 19)
//    header.numberOfLines = 0
//    header.text = "Get started"
//    
//    let notificationsLabel = UILabel()
//    notificationsLabel.font = .systemFont(ofSize: 17)
//    notificationsLabel.numberOfLines = 0
//    notificationsLabel.text = "Allow the app to sound an alarm when one of your timers finishes:"
//    
//    let notificationsButton = RoundedRectButton()
//    notificationsButton.titleLabel?.font = .boldSystemFont(ofSize: 19)
//    notificationsButton.setTitle(
//        "Allow Notifications",
//        for: .normal)
//    
//    let stackView = UIStackView(
//        arrangedSubviews: [
//            header,
//            notificationsLabel,
//            notificationsButton,
//        ])
//    stackView.axis = .vertical
//    stackView.spacing = 14
//    stackView.setCustomSpacing(20, after: notificationsLabel)
//    stackView.alignment = .leading
//    
//    // Bindings
//    
//    notificationsButton.reactive
//        .controlEvents(.touchUpInside)
//        .map { _ in }
//        .observeValues(enableNotifications)
//    
//    return stackView
//}
