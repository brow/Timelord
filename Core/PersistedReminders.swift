import ReactiveSwift
import UserNotifications

public let persistedReminders: MutableProperty<[Reminder]> = {
    let reminders = MutableProperty<[Reminder]>(
        userDefaults: sharedDefaults,
        key: "Reminders",
        defaultValue: [])
    
    reminders
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
    
    return reminders
}()



private let userNotificationCenter = UNUserNotificationCenter.current()

private let sharedDefaults = UserDefaults(
    suiteName: "group.com.tombrow.timelord2")!
