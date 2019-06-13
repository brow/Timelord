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
        
        let sortedReminders = PersistedReminders.sortedReminders
        
        let hasReminders = sortedReminders
            .map { !$0.isEmpty }
            .skipRepeats()
        
        let tableViewModel = Property
            .combineLatest(
                sortedReminders,
                notificationsAreEnabled)
            .map { persistedReminders, notificationsAreEnabled -> TableViewModel in
                var rows = [Row.header(showsSeparator: hasReminders)]
                rows.append(
                    contentsOf: persistedReminders.map(Row.reminder))
                rows.append(
                    notificationsAreEnabled
                        ? .instructions
                        : .notifications(
                            enable: enableNotifications))
                return TableViewModel(sectionModels: [
                    TableSectionViewModel(
                        diffingKey: "main",
                        cellViewModels: rows),
                ])
            }
        
        let driver = TableViewDriver(
            tableView: tableView,
            tableViewModel: tableViewModel.value)
        driver.deletionAnimation = .left
        driver.insertionAnimation = .right
        
        tableViewModel
            .producer
            .take(during: reactive.lifetime)
            .startWithValues { driver.tableViewModel = $0 }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum Row: TableCellViewModel {
    case header(showsSeparator: Property<Bool>)
    case instructions
    case notifications(enable: () -> ())
    case reminder(Reminder)
    
    var diffingKey: DiffingKey {
        switch self {
        case .header:
            return "header"
        case .instructions:
            return "instructions"
        case .notifications:
            return "notifications"
        case .reminder(let reminder):
            return reminder.id.uuidString
        }
    }
    
    public var registrationInfo: ViewRegistrationInfo {
        return ViewRegistrationInfo(classType: {
            switch self {
            case .header:
                return HeaderCell.self
            case .instructions:
                return InstructionsCell.self
            case .notifications:
                return NotificationsCell.self
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
        case .header, .instructions, .notifications:
            return UITableView.automaticDimension
        case .reminder:
            return ReminderCell.height
        }
    }
    
    public func applyViewModelToCell(_ cell: UITableViewCell) {
        switch self {
        case .instructions:
            break
        case .header(let showsSeparator):
            guard
                let cell = cell as? HeaderCell
                else { return }
            cell.showsSeparator.value = showsSeparator
        case .notifications(let enable):
            guard
                let cell = cell as? NotificationsCell
                else { return }
            cell.enableNotifications = enable
        case .reminder(let reminder):
            guard
                let cell = cell as? ReminderCell
                else { return }
            cell.model.value = reminder
        }
    }
    
    var editingStyle: UITableViewCell.EditingStyle {
        switch self {
        case .header, .instructions, .notifications:
            return .none
        case .reminder:
            return .delete
        }
    }
    
    var commitEditingStyle: CommitEditingStyleClosure? {
        switch self {
        case .header, .instructions, .notifications:
            return nil
        case .reminder(let reminder):
            return { _ in PersistedReminders.removeReminder(id: reminder.id) }
        }
    }
}
