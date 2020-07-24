import AVFoundation
import UIKit
import EasyPeasy

final class ScannerViewController: UIViewController {
    
    // MARK: Internal properties
    weak var delegate: ScannerViewControllerDelegate?
    
    // MARK: Private properties
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        initialiseCamera()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if captureSession?.isRunning == false {
            captureSession?.startRunning()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // TODO: remove temporary fix
        #if targetEnvironment(simulator)
        delegate?.scannerViewController(self, didScan: "secret")
        #endif
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession?.isRunning == true {
            captureSession?.stopRunning()
        }
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate -

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession?.stopRunning()
        
        guard let readableObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            let code = readableObject.stringValue else {
                failed(error: .unknown)
                return
        }
        
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        delegate?.scannerViewController(self, didScan: code)
    }
}

// MARK: - ConfigurableView -

extension ScannerViewController: ConfigurableView {
    
    func configureViewProperties() {
        view.backgroundColor = .black
    }
}

// MARK: - Private methods -

private extension ScannerViewController {
    
    func initialiseCamera() {
        let captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            failed(error: .initialization)
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed(error: .initialization)
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed(error: .initialization)
            return
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(previewLayer, at: 0)

        captureSession.startRunning()
        
        self.captureSession = captureSession
        self.previewLayer = previewLayer
    }
    
    func failed(error: ScannerError) {
        captureSession = nil
        delegate?.scannerViewController(self, didFail: error)
    }
}
