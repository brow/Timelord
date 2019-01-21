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
            let startDate = Calendar.current.date(
                from: startDateComponents)
            else { return nil }
        name = task.title.spokenPhrase
        date = startDate
    }
}
