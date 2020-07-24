import UIKit
import EasyPeasy

final class ChallengeInfoView: UIView {
    
    var shouldFadeContent: Bool = false {
        didSet {
            if shouldFadeContent {
                subtitleLabel.layer.mask = gradientLayer
            } else {
                subtitleLabel.layer.mask = nil
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: subtitleLabel.frame.minY + subtitleLabel.intrinsicContentSize.height)
    }
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let durationInfoView = InfoView()
    private let participantsInfoView = InfoView()
    private let pointsInfoView = InfoView()
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - subtitleLabel.frame.minY)
    }
    
    func update(for viewModel: ChallengeInfoPresentable) {
        titleLabel.text = viewModel.titleBack
        subtitleLabel.text = viewModel.subtitleBack
        durationInfoView.update(for: viewModel.durationAdditionalInfo)
        participantsInfoView.update(for: viewModel.participantsAdditionalInfo)
        pointsInfoView.update(for: viewModel.pointsAdditionalInfo)
    }
}

// MARK: - ConfigurableView -

extension ChallengeInfoView: ConfigurableView {
    
    func configureSubviews() {
        titleLabel.numberOfLines = 0
        titleLabel.font = StyleGuide.Fonts.ChallengeInfoView.title
        titleLabel.textColor = StyleGuide.Colors.GreyTones.black
        addSubview(titleLabel)
        
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = StyleGuide.Fonts.ChallengeInfoView.subtitle
        subtitleLabel.textColor = StyleGuide.Colors.GreyTones.midGrey
        subtitleLabel.contentMode = .topLeft
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
        let interItemSpacing: CGFloat = 12
        let interAdditionalInfo: CGFloat = 6
        
        titleLabel.easy.layout(
            Top(),
            Leading(),
            Trailing()
        )
        
        durationInfoView.easy.layout(
            Top(interItemSpacing).to(titleLabel),
            Leading(),
            Height(24)
        )
        
        participantsInfoView.easy.layout(
            Top().to(durationInfoView, .top),
            Leading(>=interAdditionalInfo).to(durationInfoView),
            CenterX(),
            Bottom().to(durationInfoView, .bottom),
            Height().like(durationInfoView)
        )
        
        pointsInfoView.easy.layout(
            Top().to(participantsInfoView, .top),
            Leading(>=interAdditionalInfo).to(participantsInfoView),
            Trailing(),
            Bottom().to(participantsInfoView, .bottom),
            Height().like(participantsInfoView)
        )
        
        subtitleLabel.easy.layout(
            Top(interItemSpacing).to(durationInfoView),
            Leading(),
            Trailing(),
            Bottom(<=0)
        )
    }
}
