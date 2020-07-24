import UIKit

private enum Constants {
    static let trackHeight: CGFloat = 8
}

final class GHDiscreteSlider: UISlider {
    
    override var minimumValue: Float {
        didSet {
            self.oldValue = minimumValue
            addMarks()
            updateMarkPositions()
        }
    }
    
    override var maximumValue: Float {
        didSet {
            addMarks()
            updateMarkPositions()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            updateMarkPositions()
        }
    }
    
    private let marksLayer = CALayer()
    private let feedbackGenerator = UIImpactFeedbackGenerator()
    private var oldValue: Float = .nan
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        
        oldValue = minimumValue
        addTarget(self, action: #selector(onTouchUpInside), for: .touchUpInside)
        addTarget(self, action: #selector(onValueChanged), for: .valueChanged)
        feedbackGenerator.prepare()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        guard let topLayer = layer.sublayers?.last else { return }
        layer.insertSublayer(marksLayer, below: topLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let originalTrackRect = super.trackRect(forBounds: bounds)
        let yOffset = -(Constants.trackHeight - originalTrackRect.height) / 2
        let frame = CGRect(x: originalTrackRect.minX, y: originalTrackRect.minY + yOffset, width: originalTrackRect.width, height: Constants.trackHeight)
        return frame
    }
}

// MARK: - ConfigurableView -

extension GHDiscreteSlider: ConfigurableView {
    
    func configureViewProperties() {
        minimumTrackTintColor = StyleGuide.Colors.GreyTones.lightGrey
        maximumTrackTintColor = StyleGuide.Colors.GreyTones.lightGrey
    }
}

// MARK: - Private methods -

private extension GHDiscreteSlider {
    
    @objc
    func onTouchUpInside() {
        setValue(roundf(value), animated: true)
    }
    
    @objc
    func onValueChanged() {
        let markValue = roundf(value)
        guard markValue != oldValue, (value - markValue < 0.05) else { return }
        
        oldValue = markValue
        
        feedbackGenerator.impactOccurred()
        feedbackGenerator.prepare()
    }
    
    func addMarks() {
        let numberOfMarks = Int(maximumValue - minimumValue + 1)
        
        for _ in 0..<numberOfMarks {
            let markLayer = CALayer()
            markLayer.backgroundColor = StyleGuide.Colors.GreyTones.midGrey.cgColor
            marksLayer.addSublayer(markLayer)
        }
    }
    
    func updateMarkPositions() {
        marksLayer.frame = bounds
        
        let trackRect = self.trackRect(forBounds: bounds)
        let markWidth: CGFloat = 1
        marksLayer.sublayers?.enumerated().forEach { index, layer in
            let thumbRect = self.thumbRect(forBounds: bounds, trackRect: trackRect, value: Float(index) + minimumValue)
            let xPosition = thumbRect.midX - (markWidth / 2)
            let yPosition = trackRect.minY
            layer.frame = CGRect(x: xPosition, y: yPosition, width: markWidth, height: Constants.trackHeight)
        }
    }
}
