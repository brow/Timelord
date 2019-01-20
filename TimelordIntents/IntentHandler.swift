import Intents

class IntentHandler: INExtension,
    INAddTasksIntentHandling
{
    // MARK: INAddTasksIntentHandling
    
    func handle(
        intent: INAddTasksIntent,
        completion: @escaping (INAddTasksIntentResponse) -> Void)
    {
        print(intent)
//        let userActivity = NSUserActivity(activityType: NSStringFromClass(INAddTasksIntent.self))
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
