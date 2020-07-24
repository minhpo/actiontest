import UIKit
import EasyPeasy

private enum Constants {
    static let verticalMargin: CGFloat = 20
}

final class ChallengeProgramInfoCardContentView: UIView, CardContentView {
    
    var topInset: CGFloat = 0 {
        didSet {
            let verticalMargin: CGFloat = Constants.verticalMargin + topInset
            infoView.easy.layout(
                Top(verticalMargin)
            )
        }
    }
    
    private let infoView = ChallengeProgramInfoView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(for viewModel: ChallengeProgramInfoViewPresentable) {
        infoView.update(for: viewModel)
    }
}

// MARK: - ConfigurableView -

extension ChallengeProgramInfoCardContentView: ConfigurableView {
    
    func configureViewProperties() {
        backgroundColor = StyleGuide.Colors.GreyTones.white
        isUserInteractionEnabled = false
    }
    
    func configureSubviews() {
        addSubview(infoView)
    }
    
    func configureLayout() {
        let horizontalMargin: CGFloat = StyleGuide.Margins.default
        let verticalMargin: CGFloat = Constants.verticalMargin + topInset
        
        infoView.easy.layout(
            Leading(horizontalMargin),
            Trailing(horizontalMargin),
            Top(verticalMargin),
            Bottom(<=verticalMargin)
        )
    }
}
