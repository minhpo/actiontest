import UIKit
import AVKit

final class VideoPreviewView: UIView {
    
    private let url: URL
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    private var playerLayer: AVPlayerLayer {
        guard let playerLayer = layer as? AVPlayerLayer else { fatalError("Incorrect layer") }
        return playerLayer
    }
    
    init(url: URL) {
        self.url = url
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        playerLayer.player?.pause()
        playerLayer.player = nil
    }
}

// MARK: - ConfigurableView -

extension VideoPreviewView: ConfigurableView {
    
    func configureViewProperties() {
        playerLayer.player = AVPlayer(url: url)
    }
}
