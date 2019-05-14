import Foundation
import Intents

public struct Reminder: Hashable, Codable {
    public let name: String
    public let date: Date
    
    public init(name: String, date: Date) {
        self.name = name
        self.date = date
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
