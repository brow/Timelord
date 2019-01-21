import Intents

class IntentHandler: INExtension,
    INAddTasksIntentHandling
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
            return .success(
                with: INTemporalEventTrigger(
                    dateComponentsRange: INDateComponentsRange(
                        start: startDateComponents,
                        end: nil)))
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
                dateComponentsRange: INDateComponentsRange(
                    start: startDateComponents,
                    end: nil))
            let response = INAddTasksIntentResponse(
                code: .success,
                userActivity: nil)
            response.addedTasks = taskTitles.map { title in
                INTask(
                    title: title,
                    status: .notCompleted,
                    taskType: .notCompletable,
                    spatialEventTrigger: nil,
                    temporalEventTrigger: temporalEventTrigger,
                    createdDateComponents: nil,
                    modifiedDateComponents: nil,
                    identifier: nil)
            }
            return response
        }())
    }
}

extension INAddTasksIntent {
    var startDateComponents: DateComponents? {
        return temporalEventTrigger?
            .dateComponentsRange
            .startDateComponents
    }
}

struct Task {
    let name: String
    let date: Date
}
