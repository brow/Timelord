import ReactiveSwift

struct PersistedValue<Value: Codable>  {
    let value: Property<Value>
    let set: (Value) -> ()
    
    init(
        userDefaults: UserDefaults,
        key: String,
        defaultValue: Value)
    {
        let decode = { try? decoder.decode(Value.self, from: $0) }
        
        holder = MutableProperty(
            userDefaults
                .data(forKey: key)
                .flatMap(decode)
                ?? defaultValue)
        value = Property(holder)
        
        // In UserDefaults, KVO is the only documented way I've found to be
        // notified of changes to the defaults that includes changes from
        // other processes.
        userDefaults.reactive
            .producer(forKeyPath: key)
            .startWithValues { [holder] data in
                if let data = data as? Data, let value = decode(data) {
                    holder.value = value
                }
            }
        
        set = { value in
            if let data = try? encoder.encode(value) {
                userDefaults.set(data, forKey: key)
            }
        }
    }
    
    // MARK: private
    
    private let holder: MutableProperty<Value>
}

private let (encoder, decoder) = (JSONEncoder(), JSONDecoder())
