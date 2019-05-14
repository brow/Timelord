import UIKit
import ReactiveSwift
import ReactiveCocoa
import Core

final class ReminderCell: UITableViewCell {
    let model = MutableProperty<Reminder?>(nil)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(
            style: .value1,
            reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        let textLabel = UILabel()
        textLabel.numberOfLines = 2
        textLabel.font = UIFont.boldSystemFont(ofSize: 17)
        contentView.addSubview(textLabel)
        
        let detailTextLabel = UILabel()
        detailTextLabel.font = .monospacedDigitSystemFont(
            ofSize: 32,
            weight: .regular)
        detailTextLabel.textColor = .brand
        contentView.addSubview(detailTextLabel)
        
        // Layout
        
        let marginsGuide = contentView.layoutMarginsGuide
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.leadingAnchor
            .constraint(equalTo: marginsGuide.leadingAnchor)
            .isActive = true
        textLabel.centerYAnchor
            .constraint(equalTo: marginsGuide.centerYAnchor)
            .isActive = true
        textLabel.trailingAnchor
            .constraint(
                lessThanOrEqualTo: detailTextLabel.leadingAnchor,
                constant: -10)
            .isActive = true
        
        detailTextLabel.setContentCompressionResistancePriority(
            .required,
            for: .horizontal)
        detailTextLabel.translatesAutoresizingMaskIntoConstraints = false
        detailTextLabel.trailingAnchor
            .constraint(equalTo: marginsGuide.trailingAnchor)
            .isActive = true
        detailTextLabel.centerYAnchor
            .constraint(equalTo: marginsGuide.centerYAnchor)
            .isActive = true
        
        // Bindings
        
        let model = self.model.producer.skipNil()
        
        textLabel.reactive.text <~ model
            .map { $0.name }
            .skipRepeats()
        
        detailTextLabel.reactive.text <~ SignalProducer
            .combineLatest(
                currentDate,
                model.map { $0.date }.skipRepeats())
            .map(formatTimeRemaining(from:to:))
            .skipRepeats()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private let currentDate = Property(
    initial: Date(),
    then: SignalProducer.timer(
        interval: .milliseconds(1000),
        on: QueueScheduler.main,
        // Apple power efficiency guidelines suggest leeway be at least 10% of
        // the interval, but we ignore that advice for perceptible accuracy.
        leeway: .milliseconds(10)))
