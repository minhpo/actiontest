import UIKit
import EasyPeasy
import Kingfisher

final class ChallengeImageBannerView: UIView {
    
    private let viewModel: ChallengeImageBannerViewPresentable
    private let imageView = UIImageView()
    
    init(viewModel: ChallengeImageBannerViewPresentable) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ConfigurableView -

extension ChallengeImageBannerView: ConfigurableView {
    
    func configureViewProperties() {
        backgroundColor = viewModel.backgroundColor
    }
    
    func configureSubviews() {
        imageView.contentMode = .scaleAspectFit
        imageView.kf.setImage(with: viewModel.url,
                              placeholder: UIImage(named: "icon.logo"),
                              completionHandler: { [weak self] result in
                                guard case .success = result else { return }
                                self?.imageView.contentMode = .scaleAspectFill
        })
        addSubview(imageView)
    }
    
    func configureLayout() {
        imageView.easy.layout(
            Edges()
        )
    }
}
