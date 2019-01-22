import IntentsUI
import ReactiveSwift
import Core

class IntentViewController: UITableViewController, INUIHostedViewControlling {
    
    // MARK: INUIHostedViewControlling
    
    func configureView(
        for parameters: Set<INParameter>,
        of interaction: INInteraction,
        interactiveBehavior: INUIInteractiveBehavior,
        context: INUIHostedViewContext,
        completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void)
    {
        reminders = parameters
            .compactMap(interaction.parameterValue(for:))
            .compactMap { $0 as? INTask }
            .compactMap(Reminder.init(task:))
        tableView.reloadData()
        
        let configuredParameters = parameters
        let desiredSize = tableView.contentSize
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
        
        tableView.register(
            ReminderCell.self,
            forCellReuseIdentifier: cellIdentifier)
    }
    
    // MARK: private
    
    private var reminders: [Reminder] = []
}

private let cellIdentifier = "Reminder"
