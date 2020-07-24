import UIKit

private enum Constants {
    static let emitterLayerId: String = "emitterLayerId"
}

final class ConfettiDecorator {
    
    private var view: UIView?
    private var observerToken: NSKeyValueObservation?
    
    func attach(to target: UIView) {
        detach()
        
        let emitterLayer = makeEmitterLayer()
        target.layer.addSublayer(emitterLayer)
        updateEmittingOrigin(for: emitterLayer, in: target.layer.bounds)
        observerToken = target.layer.observe(\.bounds, options: .new) { [weak self] _, change in
            guard let frame = change.newValue else { return }
            self?.updateEmittingOrigin(for: emitterLayer, in: frame)
        }
        
        view = target
    }
    
    func detach() {
        observerToken?.invalidate()
        if let emitterLayer = view?.layer.sublayers?.first(where: { $0.name == Constants.emitterLayerId }) as? CAEmitterLayer {
            emitterLayer.removeFromSuperlayer()
        }
    }
}

// MARK: - Private methods -

private extension ConfettiDecorator {
    
    func makeEmitterLayer() -> CAEmitterLayer {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.name = Constants.emitterLayerId
        emitterLayer.emitterShape = CAEmitterLayerEmitterShape.line
        emitterLayer.opacity = 0.5
        emitterLayer.beginTime = CACurrentMediaTime()
        
        let confettiShape1 = UIImage(named: "icon.confetti.box")
        let confettiShape2 = UIImage(named: "icon.confetti.triangle")
        emitterLayer.emitterCells = [
            makeEmitterCell(color: StyleGuide.Colors.Primary.ghGreen, image: confettiShape1),
            makeEmitterCell(color: StyleGuide.Colors.Secondary.yellow, image: confettiShape1),
            makeEmitterCell(color: StyleGuide.Colors.Secondary.lightBlue, image: confettiShape2),
            makeEmitterCell(color: StyleGuide.Colors.Tertiary.red, image: confettiShape2)
        ]
        
        return emitterLayer
    }
    
    func makeEmitterCell(color: UIColor, image: UIImage?) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.contents = image?.cgImage
        cell.birthRate = 15.0
        cell.lifetime = 10.0
        cell.velocity = 250
        cell.velocityRange = cell.velocity / 2
        cell.yAcceleration = -15
        cell.emissionLongitude = .pi
        cell.emissionRange = .pi / 4
        cell.spinRange = .pi * 6
        cell.scaleRange = 0.25
        cell.scale = 0.3
        cell.color = color.cgColor
        
        return cell
    }
    
    func updateEmittingOrigin(for emitter: CAEmitterLayer, in frame: CGRect) {
        emitter.emitterPosition = CGPoint(x: frame.midX, y: -50)
        emitter.emitterSize = CGSize(width: frame.width, height: 0)
    }
}
