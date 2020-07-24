import UIKit

protocol ScannerViewControllerDelegate: AnyObject {
    func scannerViewController(_ scannerViewController: ScannerViewController, didScan code: String)
    func scannerViewController(_ scannerViewController: ScannerViewController, didFail error: ScannerError)
}
