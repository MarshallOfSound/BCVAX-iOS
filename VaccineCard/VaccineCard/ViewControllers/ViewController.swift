//
//  ViewController.swift
//  VaccineCard
//
//  Created by Amir Shayegh on 2021-08-25.
//

import UIKit

class ViewController: ScannerViewController {
    
    enum Segues: String {
        case showScanResult = "showScanResult"
    }
    
    private var result: ScanResultModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier,
           id == Segues.showScanResult.rawValue,
           let destination = segue.destination as? ScanResultViewController,
           let result = result
           {
            // Disable swipe to dismiss
            if #available(iOS 13.0, *) {
                destination.isModalInPresentation = true
            } else {
                destination.modalPresentationStyle = .fullScreen
            }
            // Set values on result controller
            destination.setup(model: result) { [weak self] in
                guard let `self` = self else {return}
                // On close, Dismiss results and start capture session
                destination.dismiss(animated: true, completion: nil)
                self.captureSession.startRunning()
            }
        }
    }
    
    /// Function called when a QR code is found
    /// - Parameter code: QR code string
    override func found(code: String) {
        view.startLoadingIndicator()
        // Validate
        CodeValidationService.shared.validate(code: code) { [weak self] status in
            guard let `self` = self else {return}
            self.view.endLoadingIndicator()
            if status != .notVaccineCard {
                // If it's a vaccine card, show results
                // TODO:
                self.result = ScanResultModel(name: "Jane Doe", status: .Vaccinated)
                self.showResult()
            } else {
                // Otherwise show an error
            }
        }
    }
    
    /// Show results of QR scan
    func showResult() {
        self.performSegue(withIdentifier: Segues.showScanResult.rawValue, sender: self)
    }
    
    
}
