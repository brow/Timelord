import Foundation
import Intents

public struct Reminder: Hashable, Codable {
    public let name: String
    public let date: Date
    
    public init(name: String, date: Date) {
        self.name = name
        self.date = date
    }
}

