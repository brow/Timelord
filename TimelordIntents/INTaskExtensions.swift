import Core
import Intents

extension INTask {
    convenience init(
        reminder: Reminder,
        temporalEventTrigger: INTemporalEventTrigger?)
    {
        self.init(
            title: INSpeakableString(spokenPhrase: reminder.name),
            status: .notCompleted,
            taskType: .notCompletable,
            spatialEventTrigger: nil,
            temporalEventTrigger: temporalEventTrigger,
            createdDateComponents: nil,
            modifiedDateComponents: nil,
            identifier: reminder.id.uuidString)
    }
}
