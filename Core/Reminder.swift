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
    
    // MARK: Hashable
    
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
    
    // MARK: Equatable
    
    public static func ==(lhs: Reminder, rhs: Reminder) -> Bool {
        return lhs.id == rhs.id
    }
}
