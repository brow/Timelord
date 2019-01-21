import IntentsUI
import ReactiveSwift

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
        
        // FIXME
        SignalProducer
            .timer(
                interval: .milliseconds(50),
                on: QueueScheduler.main,
                leeway: .milliseconds(10))
            .startWithValues { print($0) }
        
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
        let reminder = reminders[indexPath.row]
        let cellIdentifier = "Cell"
        let cell = tableView
            .dequeueReusableCell(
                withIdentifier: cellIdentifier)
            ?? UITableViewCell(
                style: .value1,
                reuseIdentifier: cellIdentifier)
        cell.textLabel?.text = reminder.name
        cell.detailTextLabel?.text = "20:00"
        return cell
    }
    
    // MARK: private
    
    private var reminders: [Reminder] = []
}

private struct Reminder {
    let name: String
    let date: Date
    
    init?(task: INTask) {
        guard
            let startDateComponents = task
                .temporalEventTrigger?
                .dateComponentsRange
                .startDateComponents,
            let startDate = Calendar.current.date(
                from: startDateComponents)
            else { return nil }
        name = task.title.spokenPhrase
        date = startDate
    }
}
