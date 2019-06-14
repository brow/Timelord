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
        
        userDefaults.reactive
            .producer(forKeyPath: key)
            .startWithValues { [holder] data in
                if let data = data as? Data, let value = decode(data) {
                    holder.value = value
                }
            }
        
        set = { value in
            guard
                let data = try? encoder.encode(value)
                else { return }
            userDefaults.set(data, forKey: key)
        }
    }
    
    // MARK: private
    
    private let holder: MutableProperty<Value>
}

private let (encoder, decoder) = (JSONEncoder(), JSONDecoder())
