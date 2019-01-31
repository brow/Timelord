import UIKit

final class RoundedRectButton: UIButton {
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        clipsToBounds = true
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .init(width: 0, height: 1)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.4
        
        setContentCompressionResistancePriority(
            .required,
            for: .horizontal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIControl
    
    override var isHighlighted: Bool {
        didSet { alpha = isHighlighted ? 0.6 : 1 }
    }
    
    // MARK: UIView
    
    public override func draw(_ rect: CGRect) {
        tintColor.setFill()
        let path = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: 8)
        path.fill()
    }
}
