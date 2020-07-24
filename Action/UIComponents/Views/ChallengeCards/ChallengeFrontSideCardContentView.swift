import UIKit
import EasyPeasy

final class ChallengeFrontSideCardContentView: UIView, CardContentView {
    
    private let imageLayoutGuide = UILayoutGuide()
    private let iconImageView = UIImageView(image: UIImage(named: "icon.logo"))
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let durationInfoView = InfoView()
    private let participantsInfoView = InfoView()
    private let pointsInfoView = InfoView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(for viewModel: ChallengeFrontSideCardContentViewPresentable) {
        titleLabel.text = viewModel.challengeInfo.titleFront
        subtitleLabel.text = viewModel.challengeInfo.subtitleFront
        backgroundColor = viewModel.backgroundColor
        
        durationInfoView.update(for: viewModel.challengeInfo.durationAdditionalInfo)
        participantsInfoView.update(for: viewModel.challengeInfo.participantsAdditionalInfo)
        pointsInfoView.update(for: viewModel.challengeInfo.pointsAdditionalInfo)
    }
}

// MARK: - ConfigurableView -

extension ChallengeFrontSideCardContentView: ConfigurableView {
    
    func configureViewProperties() {
        isUserInteractionEnabled = false
    }
    
    func configureSubviews() {
        addLayoutGuide(imageLayoutGuide)
        
        iconImageView.contentMode = .scaleAspectFit
        addSubview(iconImageView)
        
        titleLabel.numberOfLines = 0
        titleLabel.font = StyleGuide.Fonts.ChallengeInfoView.title
        titleLabel.textColor = StyleGuide.Colors.GreyTones.darkGrey.withAlphaComponent(0.7)
        addSubview(titleLabel)
        
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = StyleGuide.Fonts.ChallengeInfoView.subtitle
        subtitleLabel.textColor = StyleGuide.Colors.GreyTones.black.withAlphaComponent(0.4)
        addSubview(subtitleLabel)
        
        let additionalInfoTintColor: UIColor = StyleGuide.Colors.GreyTones.darkGrey.withAlphaComponent(0.5)
        durationInfoView.tintColor = additionalInfoTintColor
        addSubview(durationInfoView)
        
        participantsInfoView.tintColor = additionalInfoTintColor
        addSubview(participantsInfoView)
        
        pointsInfoView.tintColor = additionalInfoTintColor
        addSubview(pointsInfoView)
    }
    
    func configureLayout() {
        let margin: CGFloat = 16
        let interItemSpacing: CGFloat = 6
        imageLayoutGuide.easy.layout(
            Leading(),
            Trailing(),
            Top(),
            Height(*0.5).like(self)
        )
        
        iconImageView.easy.layout(
            CenterX().to(imageLayoutGuide),
            CenterY().to(imageLayoutGuide),
            Width(*0.28).like(self)
        )
        
        titleLabel.easy.layout(
            Top().to(imageLayoutGuide),
            Leading(margin),
            Trailing(margin)
        )
        
        subtitleLabel.easy.layout(
            Top(interItemSpacing).to(titleLabel),
            Leading(margin),
            Trailing(margin)
        )
        
        durationInfoView.easy.layout(
            Top(>=interItemSpacing).to(subtitleLabel),
            Leading(margin),
            Bottom(margin),
            Height(24)
        )
        
        participantsInfoView.easy.layout(
            Top().to(durationInfoView, .top),
            Leading(>=interItemSpacing).to(durationInfoView),
            CenterX(),
            Bottom().to(durationInfoView, .bottom),
            Height().like(durationInfoView)
        )
        
        pointsInfoView.easy.layout(
            Top().to(participantsInfoView, .top),
            Leading(>=interItemSpacing).to(participantsInfoView),
            Trailing(margin),
            Bottom().to(participantsInfoView, .bottom),
            Height().like(participantsInfoView)
        )
    }
}
