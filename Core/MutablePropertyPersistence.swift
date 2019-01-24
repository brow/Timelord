import ReactiveSwift

public extension MutableProperty where Value: Codable {
    convenience init(
        userDefaults: UserDefaults,
        key: String,
        defaultValue: Value)
    {
        self.init(
            userDefaults
                .data(forKey: key)
                .flatMap { try? decoder.decode(Value.self, from: $0) }
                ?? defaultValue)
        
        producer
            .map { try? encoder.encode($0) }
            .skipNil()
            .skipRepeats()
            .take(during: lifetime)
            .startWithValues { userDefaults.set($0, forKey: key) }
        
        // TODO: listen for UserDefaults.didChangeNotification to react to
        // changes to this preference from outside Preference (incl. outside
        // the process).
    }
}

private let (encoder, decoder) = (JSONEncoder(), JSONDecoder())
