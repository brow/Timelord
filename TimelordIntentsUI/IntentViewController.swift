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
            // As the docs say, "SiriKit calls this method method once with zero
            // parameters… If there are still parameters to be displayed,
            // SiriKit calls this method one or more additional times with a set
            // of INParameter objects."
            //
            // I don't understand why SiriKit does that, but if we return true
            // multiple times, the resulting UI contains multiple
            // IntentViewControllers stacked vertically. We only want one, so
            // we must return false in the empty parameters case.
            !parameters.isEmpty,
            parameters,
            tableView.contentSize)
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
        return 1
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
        cell.detailTextLabel?.text = "20:00"
        return cell
    }
}
