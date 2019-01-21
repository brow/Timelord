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
                let trigger = intent.temporalEventTrigger,
                let startDateComponents = trigger
                    .dateComponentsRange
                    .startDateComponents
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
        let response = INAddTasksIntentResponse(
            code: .success,
            userActivity: nil)
        response.addedTasks = [
            INTask(
                title: INSpeakableString(spokenPhrase: "Fake task"),
                status: .notCompleted,
                taskType: .notCompletable,
                spatialEventTrigger: nil,
                temporalEventTrigger: nil,
                createdDateComponents: nil,
                modifiedDateComponents: nil,
                identifier: "faketask")
            ]
        completion(response)
    }
}
