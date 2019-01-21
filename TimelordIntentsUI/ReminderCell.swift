import UIKit
import ReactiveSwift
import ReactiveCocoa

final class ReminderCell: UITableViewCell {
    let model = MutableProperty<Reminder?>(nil)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(
            style: .value1,
            reuseIdentifier: reuseIdentifier)
        
        // Bindings
        
        let model = self.model.producer.skipNil()
        
        if let textLabel = textLabel {
            textLabel.reactive.text <~ model.map { $0.name }.skipRepeats()
        }
        if let detailTextLabel = detailTextLabel {
            detailTextLabel.reactive.text <~ SignalProducer
                .combineLatest(
                    currentDate,
                    model.map { $0.date }.skipRepeats())
                .map(timeRemainingFormatter.string(from:to:))
                .map { $0 ?? "" }

        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private let timeRemainingFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .positional
    formatter.allowedUnits = [.hour, .minute, .second]
    return formatter
}()

private let currentDate = Property(
    initial: Date(),
    then: SignalProducer.timer(
        interval: .milliseconds(50),
        on: QueueScheduler.main,
        leeway: .milliseconds(10)))
