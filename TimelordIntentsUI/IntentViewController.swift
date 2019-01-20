import IntentsUI

class IntentViewController: UITableViewController, INUIHostedViewControlling {
    
    // MARK: INUIHostedViewControlling
    
    func configureView(
        for parameters: Set<INParameter>,
        of interaction: INInteraction,
        interactiveBehavior: INUIInteractiveBehavior,
        context: INUIHostedViewContext,
        completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void)
    {
        completion(
            true,
            parameters,
            self.extensionContext!.hostedViewMaximumAllowedSize)
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
        return 2
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cellIdentifier = "Cell"
        let cell = tableView
            .dequeueReusableCell(
                withIdentifier: cellIdentifier)
            ?? UITableViewCell(
                style: .value1,
                reuseIdentifier: cellIdentifier)
        cell.textLabel?.text = "Take eggplant out"
        cell.detailTextLabel?.text = "30:00"
        return cell
    }
}
