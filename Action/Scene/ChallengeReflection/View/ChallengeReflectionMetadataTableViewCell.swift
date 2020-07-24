import UIKit
import EasyPeasy

final class ChallengeReflectionMetadataTableViewCell: UITableViewCell {
    
    // MARK: Private properties
    private let contentLayoutGuide = UILayoutGuide()
    private let pointsLayoutGuide = UILayoutGuide()
    private let headerLabel = UILabel()
    private let titleLabel = UILabel()
    private let pointsImage = UIImageView(image: UIImage(named: "icon.info.points")?.withRenderingMode(.alwaysTemplate))
    private let pointsLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(for viewModel: ChallengeReflectionMetadataPresentable) {
        backgroundView?.backgroundColor = viewModel.tintColor
    }
}

// MARK: - ConfigurableView -

extension ChallengeReflectionMetadataTableViewCell: ConfigurableView {
    
    func configureViewProperties() {
        selectionStyle = .none
        
        backgroundView = UIView()
        backgroundView?.layer.cornerRadius = 8
    }
    
    func configureSubviews() {
        contentView.addLayoutGuide(contentLayoutGuide)
        contentView.addLayoutGuide(pointsLayoutGuide)
        
        headerLabel.textColor = StyleGuide.Colors.GreyTones.black
        headerLabel.font = StyleGuide.Fonts.ChallengeReflection.header
        headerLabel.text = "challenge_reflection_header".localized()
        contentView.addSubview(headerLabel)
        
        titleLabel.textColor = StyleGuide.Colors.GreyTones.black
        titleLabel.font = StyleGuide.Fonts.ChallengeReflection.title
        titleLabel.numberOfLines = 0
        titleLabel.text = "challenge_reflection_title".localized()
        contentView.addSubview(titleLabel)
        
        pointsImage.tintColor = StyleGuide.Colors.GreyTones.black
        pointsImage.alpha = 0.7
        contentView.addSubview(pointsImage)
        
        pointsLabel.textColor = StyleGuide.Colors.GreyTones.black
        pointsLabel.font = StyleGuide.Fonts.ChallengeReflection.points
        pointsLabel.text = "challenge_reflection_points".localized()
        contentView.addSubview(pointsLabel)
    }
    
    func configureLayout() {
        let margin = StyleGuide.Margins.default
        let interItemSpacing: CGFloat = 8
        
        contentLayoutGuide.easy.layout(
            Edges(),
            Height(*0.75).like(contentView, .width)
        )
        
        headerLabel.easy.layout(
            Leading(margin),
            Trailing(margin)
        )
        
        titleLabel.easy.layout(
            Leading(margin),
            Top(interItemSpacing).to(headerLabel),
            Trailing(margin)
        )
        
        pointsLayoutGuide.easy.layout(
            Trailing(margin),
            Top(interItemSpacing).to(titleLabel),
            Bottom(margin)
        )
        
        pointsImage.easy.layout(
            Leading().to(pointsLayoutGuide, .leading),
            Top().to(pointsLayoutGuide, .top),
            Bottom().to(pointsLayoutGuide, .bottom)
        )
        
        pointsLabel.easy.layout(
            Leading(interItemSpacing).to(pointsImage),
            CenterY().to(pointsImage),
            Trailing().to(pointsLayoutGuide, .trailing)
        )
    }
}
