import IntentsUI
import ReactiveSwift
import Core

final class IntentViewController: UITableViewController,
    INUIHostedViewControlling
{
    // MARK: INUIHostedViewControlling
    
    func configureView(
        for parameters: Set<INParameter>,
        of interaction: INInteraction,
        interactiveBehavior: INUIInteractiveBehavior,
        context: INUIHostedViewContext,
        completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void)
    {
        let configuredParameters: Set<INParameter>
        if interaction.intentResponse is INSearchForNotebookItemsIntentResponse {
            reminders = parameters.isEmpty
                ? []
                : PersistedReminders.sortedReminders.value
            configuredParameters = Set(reminders.indices.compactMap { index in
                INParameter(
                    for: INSearchForNotebookItemsIntentResponse.self,
                    keyPath: "tasks[\(index)]")

            })
        } else {
            let taskIDs = Set(parameters
                .compactMap(interaction.parameterValue)
                .compactMap { $0 as? INTask }
                .compactMap { $0.identifier }
                .compactMap(UUID.init))
            reminders = PersistedReminders.sortedReminders
                .value
                .filter { taskIDs.contains($0.id) }
            configuredParameters = parameters
        }
        
        tableView.reloadData()
        tableView.layoutIfNeeded()
        
        var desiredSize = tableView.contentSize
        
        // Hide the final row separator
        desiredSize.height -= 1 / UIScreen.main.scale
            
        completion(
            !reminders.isEmpty,
            configuredParameters,
            desiredSize)
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int)
        -> Int
    {
        return reminders.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier,
            for: indexPath)
            as! ReminderCell
        cell.model.value = reminders[indexPath.row]
        return cell
    }
    
    // MARK: UIViewController
    
    override func loadView() {
        super.loadView()
        
        tableView.rowHeight = ReminderCell.height
        tableView.backgroundColor = .clear
        tableView.separatorColor = .gray
        tableView.register(
            ReminderCell.self,
            forCellReuseIdentifier: cellIdentifier)
    }
    
    // MARK: private
    
    private var reminders: [Reminder] = []
}

private let cellIdentifier = "Reminder"
