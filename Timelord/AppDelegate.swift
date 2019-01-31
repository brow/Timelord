import UIKit
import ReactiveSwift
import Result
import UserNotifications
import Core

@UIApplicationMain
final class AppDelegate: UIResponder,
    UIApplicationDelegate
{
    // MARK: UIApplicationDelegate
    
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
        -> Bool
    {
        let notificationCenter = NotificationCenter.default
        let userNotificationCenter = UNUserNotificationCenter.current()
        
        let notificationsNotGranted = Signal<(), NoError>.pipe()
        
        let appWasForegrounded = SignalProducer(notificationCenter.reactive
            .notifications(
                forName: UIApplication.willEnterForegroundNotification)
            .map { _ in () })
            .prefix(value: ())
        
        let notificationsAreEnabled = MutableProperty(false)
        notificationsAreEnabled <~ appWasForegrounded
            .flatMap(.latest) {
                SignalProducer { observer, _ in
                    userNotificationCenter.getNotificationSettings {
                        settings in
                        
                        observer.send(
                            value: settings.authorizationStatus == .authorized)
                        observer.sendCompleted()
                    }
                }
            }
            .observe(on: QueueScheduler.main)
        
        let enableNotifications = SignalProducer<Never, NoError> {
            observer, _ in
            
            userNotificationCenter.requestAuthorization(
                options: [.badge, .sound, .alert],
                completionHandler: { granted, error in
                    DispatchQueue.main.async {
                        notificationsAreEnabled.value = granted
                        if !granted {
                            notificationsNotGranted.input.send(value: ())
                        }
                        observer.sendCompleted()
                    }
                })
        }
        
        let rootViewController = ViewController(
            enableNotifications: { enableNotifications.start() })
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.tintColor = .brand
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window
        
        notificationsNotGranted.output.observeValues {
            let alertController = UIAlertController(
                title: "Allow Notifications",
                message: "Please open Settings and select Notifications > Allow Notifications.",
                preferredStyle: .alert)
            let cancel = UIAlertAction(
                title: "Not Now",
                style: .cancel,
                handler: nil)
            let openSettings = UIAlertAction(
                title: "Settings",
                style: .default,
                handler: { _ in application.openSettings() })
            [cancel, openSettings].forEach(alertController.addAction)
            alertController.preferredAction = openSettings
            
            rootViewController.present(
                alertController,
                animated: true,
                completion: nil)
        }
        
        return true
    }
}
