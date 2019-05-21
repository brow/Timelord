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
            
            let addedReminders = taskTitles.compactMap { title -> Reminder? in
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
            persistedReminders.modify { reminders in
                let now = Date()
                reminders.removeAll { $0.date < now }
                reminders.append(contentsOf: addedReminders)
            }
            
            response.addedTasks = addedReminders.map { reminder in
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
            let now = Date()
            let calendar = Calendar.current
            response.sortType = .asIs
            response.tasks = persistedReminders.value
                .filter { $0.date > now }
                .map { reminder in
                    INTask(
                        title: INSpeakableString(spokenPhrase: reminder.name),
                        status: .notCompleted,
                        taskType: .notCompletable,
                        spatialEventTrigger: nil,
                        // If the trigger is less than a day in the future,
                        // Siri says "found 1 overdue reminder". By setting the
                        // trigger further out, we can make Siri say "found
                        // 1 *scheduled* reminder", which seems less confusing.
                        temporalEventTrigger: INTemporalEventTrigger(
                            startDateComponents: calendar.dateComponents(
                                in: .current,
                                from: now.addingTimeInterval(86400))),
                        createdDateComponents: nil,
                        modifiedDateComponents: nil,
                        identifier: nil)
                }
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
