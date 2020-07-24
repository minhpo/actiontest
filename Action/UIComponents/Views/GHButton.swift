import UIKit
import EasyPeasy

final class GHButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: StyleGuide.DefaultSizes.buttonHeight)
    }
}

extension GHButton: ConfigurableView {
    
    func configureViewProperties() {
        layer.cornerRadius = StyleGuide.DefaultSizes.buttonHeight / 2
        titleLabel?.font = StyleGuide.Fonts.Button.title
        setTitleColor(StyleGuide.Colors.GreyTones.white, for: .normal)
        
        let margin = StyleGuide.Margins.default
        contentEdgeInsets = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
    }
}
