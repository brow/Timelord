import ReactiveSwift

public let persistedReminders = MutableProperty<[Reminder]>(
    userDefaults: sharedDefaults,
    key: "Reminders",
    defaultValue: [])

private let sharedDefaults = UserDefaults(
    suiteName: "group.com.tombrow.timelord2")!
