import Intents
import Core
import ReactiveSwift

class IntentHandler: INExtension,
    INAddTasksIntentHandling,
    INSearchForNotebookItemsIntentHandling
{
    // MARK: INAddTasksIntentHandling
    
    func resolveTemporalEventTrigger(
        for intent: INAddTasksIntent,
        with completion: @escaping (INTemporalEventTriggerResolutionResult) -> Void)
    {
        completion({
            guard
                let startDateComponents = intent.startDateComponents
                else { return .needsValue() }
            let temporalEventTrigger = INTemporalEventTrigger(
                startDateComponents: startDateComponents)
            return temporalEventTrigger == intent.temporalEventTrigger
                ? .success(
                    with: temporalEventTrigger)
                : .confirmationRequired(
                    with: temporalEventTrigger)
        }())
    }
    
    func handle(
        intent: INAddTasksIntent,
        completion: @escaping (INAddTasksIntentResponse) -> Void)
    {
        completion({
            guard
                let startDateComponents = intent.startDateComponents,
                let taskTitles = intent.taskTitles
                else {
                    return INAddTasksIntentResponse(
                        code: .failure,
                        userActivity: nil)
                }
            let temporalEventTrigger = INTemporalEventTrigger(
                startDateComponents: startDateComponents)
            let response = INAddTasksIntentResponse(
                code: .success,
                userActivity: nil)
            
            let reminders = taskTitles.compactMap { title -> Reminder? in
                guard
                    let startDateComponents = temporalEventTrigger
                        .dateComponentsRange
                        .startDateComponents,
                    let startDate = startDate(
                        components: startDateComponents)
                    else { return nil }
                return Reminder(
                    name: title.spokenPhrase,
                    date: startDate)
            }
            persistedReminders.value.append(
                contentsOf: reminders)
            
            response.addedTasks = reminders.map { reminder in
                INTask(
                    title: INSpeakableString(spokenPhrase: reminder.name),
                    status: .notCompleted,
                    taskType: .notCompletable,
                    spatialEventTrigger: nil,
                    temporalEventTrigger: nil,
                    createdDateComponents: nil,
                    modifiedDateComponents: nil,
                    identifier: nil)
            }
            return response
        }())
    }
    
    // MARK: INSearchForNotebookItemsIntentHandling
    
    func handle(
        intent: INSearchForNotebookItemsIntent,
        completion: @escaping (INSearchForNotebookItemsIntentResponse) -> Void)
    {
        completion({
            let response = INSearchForNotebookItemsIntentResponse(
                code: .success,
                userActivity: nil)
            response.tasks = persistedReminders.value.map { $0.task }
            return response
        }())
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
