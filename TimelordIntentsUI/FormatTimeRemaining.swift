import Foundation

func formatTimeRemaining(from: Date, to: Date) -> String {
    if from >= to {
        return ":00"
    }
    
    let components = Calendar.current.dateComponents(
        [.hour, .minute, .second],
        from: from,
        to: to)
    
    let hour = components.hour ?? 0
    let minute = components.minute ?? 0
    let second = components.second ?? 0
    
    if hour > 0 {
        return String(format: "%02:%02:%02d", minute, second)
    } else if minute > 0 {
        return String(format: "%02:%02d", minute, second)
    } else {
        return String(format: ":%02d", second)
    }
}
