import UIKit
import EasyPeasy

final class InfoView: UIView {
    
    override var tintColor: UIColor! {
        didSet {
            imageView.tintColor = tintColor
            textLabel.textColor = tintColor
        }
    }
    
    private let textLabel = UILabel()
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(for viewModel: InfoViewPresentable) {
        textLabel.text = viewModel.text
        imageView.image = viewModel.image.withRenderingMode(.alwaysTemplate)
    }
}

// MARK: - ConfigurableView -

extension InfoView: ConfigurableView {
    
    func configureSubviews() {
        imageView.tintColor = tintColor
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        textLabel.textColor = tintColor
        textLabel.font = StyleGuide.Fonts.InfoView.text
        addSubview(textLabel)
    }
    
    func configureLayout() {
        imageView.easy.layout(
            Leading(),
            Top(),
            Bottom()
        )
        
        textLabel.easy.layout(
            Leading(6).to(imageView),
            Top(),
            Bottom(),
            Trailing()
        )
    }
}
