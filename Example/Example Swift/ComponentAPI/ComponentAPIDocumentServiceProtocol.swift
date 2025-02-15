//
//  ComponentAPIDocumentServiceProtocol.swift
//  GiniCapture
//
//  Created by Enrique del Pozo Gómez on 3/29/18.
//

import Foundation
import GiniCapture
import GiniPayApiLib

enum CustomAnalysisError: GiniCaptureError {
    case analysisFailed
    var message: String {
        switch self {
        case .analysisFailed:
            return NSLocalizedString("analysisFailedErrorMessage", comment: "analysis failed error message")
        }
    }
}

typealias ComponentAPIUploadDocumentCompletion = (Result<Document, GiniError>) -> Void
typealias ComponentAPIAnalysisCompletion = (Result<ExtractionResult, GiniError>) -> Void

protocol ComponentAPIDocumentServiceProtocol: class {
    
    var document: Document? { get set }
    var analysisCancellationToken: CancellationToken? { get set }
    
    func cancelAnalysis()
    func remove(document: GiniCaptureDocument)
    func resetToInitialState()
    func sendFeedback(with updatedExtractions: [Extraction])
    func startAnalysis(completion: @escaping ComponentAPIAnalysisCompletion)
    func sortDocuments(withSameOrderAs documents: [GiniCaptureDocument])
    func upload(document: GiniCaptureDocument,
                completion: ComponentAPIUploadDocumentCompletion?)
    func update(imageDocument: GiniImageDocument)
}
