import UIKit
import EasyPeasy

final class GHChevronButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let originalIntrinsicContentSize = super.intrinsicContentSize
        return CGSize(width: originalIntrinsicContentSize.width, height: StyleGuide.DefaultSizes.buttonHeight)
    }
}

// MARK: - ConfigurableView -

extension GHChevronButton: ConfigurableView {
    
    func configureViewProperties() {
        titleLabel?.font = StyleGuide.Fonts.Button.title
        tintColor = StyleGuide.Colors.GreyTones.black
        setTitleColor(StyleGuide.Colors.GreyTones.black, for: .normal)
        contentMode = .left
        setImage(UIImage(named: "icon.chevron.right")?.withRenderingMode(.alwaysTemplate), for: .normal)
        semanticContentAttribute = .forceRightToLeft
    }
}
