import UIKit
import ReactiveSwift
import UserNotifications
import Core

@UIApplicationMain
final class AppDelegate: UIResponder,
    UIApplicationDelegate,
    UNUserNotificationCenterDelegate
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
        userNotificationCenter.delegate = self
        
        let notificationsNotGranted = Signal<(), Never>.pipe()
        
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
        
        let enableNotifications = SignalProducer<Never, Never> {
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
        
        persistedReminders
            .producer
            .skipRepeats()
            .startWithValues { reminders in
                userNotificationCenter.removeAllPendingNotificationRequests()

                let calendar = Calendar.current
                for reminder in reminders {
                    // If we use `Calendar.dateComponents(in:from:)` instead of
                    // specifying date components explicitly, the notification
                    // center silently fails to schedule the notification.
                    let dateComponents = calendar.dateComponents(
                        [
                            .year,
                            .month,
                            .day,
                            .hour,
                            .minute,
                            .second,
                            .nanosecond,
                            .timeZone,
                            ],
                        from: reminder.date)
                    userNotificationCenter.add(
                        UNNotificationRequest(
                            identifier: UUID().uuidString,
                            content: { () -> UNNotificationContent in
                                let content = UNMutableNotificationContent()
                                content.title = reminder.name
                                content.body = "Timer finished"
                                content.sound = UNNotificationSound(
                                    named: .init("ring.wav"))
                                return content
                            }(),
                            trigger: UNCalendarNotificationTrigger(
                                dateMatching: dateComponents,
                                repeats: false)))
                }
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
    
    // MARK: UNUserNotificationCenterDelegate
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        // Allow notifications to show when the app is open
        completionHandler([.alert, .sound, .badge])
    }
}
