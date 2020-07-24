import UIKit
import EasyPeasy

private enum Constants {
    static let margin: CGFloat = 8
}

final class QuizSubmitView: UIView {
    
    private let submitButton = GHButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let totalMargin = Constants.margin * 2
        return CGSize(width: UIView.noIntrinsicMetric, height: totalMargin + submitButton.intrinsicContentSize.height)
    }
}

// MARK: - ConfigurableView -

extension QuizSubmitView: ConfigurableView {
    
    func configureViewProperties() {
        backgroundColor = StyleGuide.Colors.GreyTones.white
    }
    
    func configureSubviews() {
        submitButton.backgroundColor = StyleGuide.Colors.Primary.ghPurple
        submitButton.setTitle("quiz_submit_button".localized(), for: .normal)
        addSubview(submitButton)
    }
    
    func configureLayout() {
        submitButton.easy.layout(
            Leading(),
            Trailing(),
            Top(Constants.margin),
            Bottom(Constants.margin)
        )
    }
}
