import UIKit
import EasyPeasy

final class ChallengeProgramInfoView: UIView {
    
    var readMoreHandler: (() -> Void)?
    
    private let titleLabel = UILabel()
    private let textLabel = UILabel()
    private let button = GHChevronButton()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(for viewModel: ChallengeProgramInfoViewPresentable) {
        titleLabel.text = viewModel.title
        titleLabel.textColor = viewModel.color
        
        textLabel.text = viewModel.text
        
        button.isHidden = viewModel.hasReadMoreUrl == false
        button.setTitleColor(viewModel.color, for: .normal)
        button.tintColor = viewModel.color
    }
}

// MARK: - ConfigurableView -

extension ChallengeProgramInfoView: ConfigurableView {
    
    func configureSubviews() {
        titleLabel.numberOfLines = 0
        titleLabel.contentMode = .topLeft
        titleLabel.font = StyleGuide.Fonts.ChallengeProgramInfo.title
        addSubview(titleLabel)
        
        textLabel.numberOfLines = 0
        textLabel.contentMode = .topLeft
        textLabel.textColor = StyleGuide.Colors.GreyTones.midGrey
        textLabel.font = StyleGuide.Fonts.ChallengeProgramInfo.text
        addSubview(textLabel)
        
        button.setTitle("challenge_program_info_button".localized(), for: .normal)
        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        addSubview(button)
    }
    
    func configureLayout() {
        let interItemSpacing: CGFloat = 20
        
        titleLabel.easy.layout(
            Top(),
            Leading(),
            Trailing()
        )
        
        textLabel.easy.layout(
            Top(interItemSpacing).to(titleLabel),
            Leading().to(titleLabel, .leading),
            Trailing().to(titleLabel, .trailing)
        )
        
        button.easy.layout(
            Top(interItemSpacing).to(textLabel),
            Leading().to(textLabel, .leading),
            Bottom()
        )
    }
}

// MARK: - Private methods -

private extension ChallengeProgramInfoView {
    
    @objc
    func onTap() {
        readMoreHandler?()
    }
}
