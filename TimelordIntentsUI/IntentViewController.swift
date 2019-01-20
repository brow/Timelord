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
}
