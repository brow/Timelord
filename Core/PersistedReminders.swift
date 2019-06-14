import ReactiveSwift
import UserNotifications

public struct PersistedReminders {
    public static func add<S: Sequence>(
        reminders: S)
        where S.Element == Reminder
    {
        persistedReminders.set(
            persistedReminders.value.value.union(reminders))
    }
    
    public static func removeReminder(id: UUID) {
        persistedReminders.set(
            persistedReminders.value.value.filter { $0.id != id })
    }
    
    public static var sortedReminders: Property<[Reminder]> {
        return persistedReminders.value
            .skipRepeats()
            .map { $0.sorted { $0.date < $1.date } }
    }
}

private let persistedReminders: PersistedValue<Set<Reminder>> = {
    let reminders = PersistedValue<Set<Reminder>>(
        userDefaults: sharedDefaults,
        key: "Reminders",
        defaultValue: [])
    
    reminders.value
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
