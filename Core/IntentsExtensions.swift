import Intents

public extension INAddTasksIntent {
    var startDateComponents: DateComponents? {
        return temporalEventTrigger?
            .dateComponentsRange
            .startDateComponents
    }
}

public extension INTemporalEventTrigger {
    convenience init(startDateComponents: DateComponents) {
        self.init(
            dateComponentsRange: INDateComponentsRange(
                start: startDateComponents,
                end: nil))
    }
}
