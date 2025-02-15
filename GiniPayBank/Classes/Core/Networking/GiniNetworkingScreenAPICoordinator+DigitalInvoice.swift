//
//  File.swift
//  GiniNetworkingScreenAPICoordinator
//
//  Created by Nadya Karaban on 28.02.21.
//

import Foundation
import GiniCapture
import GiniPayApiLib

extension GiniPayBankNetworkingScreenApiCoordinator: DigitalInvoiceViewControllerDelegate {
    public func didFinish(viewController: DigitalInvoiceViewController, invoice: DigitalInvoice) {
        guard let analysisDelegate = viewController.analysisDelegate else { return }
        deliverWithReturnAssistant(result: invoice.extractionResult, analysisDelegate: analysisDelegate)
    }
}

