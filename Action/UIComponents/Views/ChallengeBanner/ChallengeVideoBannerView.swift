import UIKit
import EasyPeasy

final class ChallengeVideoBannerView: UIView {
    
    private let viewModel: ChallengeVideoBannerViewPresentable
    private let videoPreviewView: VideoPreviewView
    private let playImageView = UIImageView(image: UIImage(named: "icon.video.play"))
    
    init(viewModel: ChallengeVideoBannerViewPresentable) {
        self.viewModel = viewModel
        videoPreviewView = VideoPreviewView(url: viewModel.url)
        super.init(frame: .zero)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ConfigurableView -

extension ChallengeVideoBannerView: ConfigurableView {
    
    func configureViewProperties() {
        backgroundColor = viewModel.backgroundColor
    }
    
    func configureSubviews() {
        addSubview(videoPreviewView)
        addSubview(playImageView)
    }
    
    func configureLayout() {
        videoPreviewView.easy.layout(
            CenterX(),
            Top(),
            Bottom(),
            Width(*(16/9)).like(videoPreviewView, .height)
        )
        
        playImageView.easy.layout(
            CenterX(),
            CenterY()
        )
    }
}
