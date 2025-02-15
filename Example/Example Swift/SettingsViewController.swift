//
//  SettingsViewController.swift
//  Example Swift
//
//  Created by Nadya Karaban on 19.02.21.
//

import Foundation
import GiniCapture
import AVFoundation

protocol SettingsViewControllerDelegate: class {
    func settings(settingViewController: SettingsViewController,
                  didChangeConfiguration captureConfiguration: GiniConfiguration)
}

final class SettingsViewController: UIViewController {
    
    weak var delegate: SettingsViewControllerDelegate?
    var giniConfiguration: GiniConfiguration!

    @IBOutlet weak var fileImportControl: UISegmentedControl!
    @IBOutlet weak var openWithSwitch: UISwitch!
    @IBOutlet weak var qrCodeScanningSwitch: UISwitch!
    @IBOutlet weak var multipageSwitch: UISwitch!
    @IBOutlet weak var flashToggleSwitch: UISwitch!
    @IBAction func fileImportOptions(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            giniConfiguration.fileImportSupportedTypes = .none
        case 1:
            giniConfiguration.fileImportSupportedTypes = .pdf
        case 2:
            giniConfiguration.fileImportSupportedTypes = .pdf_and_images
        default: return
        }
        
        delegate?.settings(settingViewController: self, didChangeConfiguration: giniConfiguration)
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openWithSwitch(_ sender: UISwitch) {
        giniConfiguration.openWithEnabled = sender.isOn
        delegate?.settings(settingViewController: self, didChangeConfiguration: giniConfiguration)
    }
    
    @IBAction func qrCodeScanningSwitch(_ sender: UISwitch) {
        giniConfiguration.qrCodeScanningEnabled = sender.isOn
        delegate?.settings(settingViewController: self, didChangeConfiguration: giniConfiguration)
    }
    
    @IBAction func multipageSwitch(_ sender: UISwitch) {
        giniConfiguration.multipageEnabled = sender.isOn
        delegate?.settings(settingViewController: self, didChangeConfiguration: giniConfiguration)

    }
    
    @IBAction func flashToggleSwitch(_ sender: UISwitch) {
        giniConfiguration.flashToggleEnabled = sender.isOn
        delegate?.settings(settingViewController: self, didChangeConfiguration: giniConfiguration)
    }
    
    @IBAction func resetUserDefaults(_ sender: Any) {
        UserDefaults().removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openWithSwitch.setOn(giniConfiguration.openWithEnabled, animated: false)
        qrCodeScanningSwitch.setOn(giniConfiguration.qrCodeScanningEnabled, animated: false)
        multipageSwitch.setOn(giniConfiguration.multipageEnabled, animated: false)
        flashToggleSwitch.setOn(giniConfiguration.flashToggleEnabled, animated: false)
        flashToggleSwitch.isEnabled = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                              for: .video,
                                                              position: .back)?.hasFlash ?? false
        
        switch giniConfiguration.fileImportSupportedTypes {
        case .none:
            fileImportControl.selectedSegmentIndex = 0
        case .pdf:
            fileImportControl.selectedSegmentIndex = 1
        case .pdf_and_images:
            fileImportControl.selectedSegmentIndex = 2
        }
    }
}
