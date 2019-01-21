import Foundation
import Intents

struct Reminder {
    let name: String
    let date: Date
    
    init?(task: INTask) {
        guard
            let startDateComponents = task
                .temporalEventTrigger?
                .dateComponentsRange
                .startDateComponents,
            let startDate = startDate(
                components: startDateComponents)
            else { return nil }
        name = task.title.spokenPhrase
        date = startDate
    }
}

private func startDate(components: DateComponents) -> Date? {
    let calendar = Calendar.current
    let currentDateComponents = calendar.dateComponents(
        [.second, .nanosecond],
        from: Date())
    
    var components = components
    components.second = currentDateComponents.second
    components.nanosecond = currentDateComponents.nanosecond
    
    return calendar.date(from: components)
}
