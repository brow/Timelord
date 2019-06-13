import Foundation
import Intents

public struct Reminder: Hashable, Codable {
    public let id: UUID
    public let name: String
    public let date: Date
    
    public init(name: String, date: Date) {
        id = UUID()
        
        self.name = name
        self.date = date
    }
}

