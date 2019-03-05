import Foundation
import Intents

public struct Reminder: Hashable, Codable {
    public let name: String
    public let date: Date
    
    public init(name: String, date: Date) {
        self.name = name
        self.date = date
    }
    
    public init?(task: INTask) {
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
    
    public var task: INTask {
        return INTask(
            title: INSpeakableString(spokenPhrase: name),
            status: .notCompleted,
            taskType: .notCompletable,
            spatialEventTrigger: nil,
            temporalEventTrigger: INTemporalEventTrigger(
                startDateComponents: Calendar.current.dateComponents(
                    in: .current,
                    from: date)),
            createdDateComponents: nil,
            modifiedDateComponents: nil,
            identifier: nil)
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
