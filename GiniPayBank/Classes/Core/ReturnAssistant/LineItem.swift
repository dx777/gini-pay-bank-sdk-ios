//
//  LineItem.swift
//  GiniPayBank
//
//  Created by Maciej Trybilo on 19.02.20.
//

import Foundation
import GiniPayApiLib

extension DigitalInvoice {
    
    struct LineItem {
        
        enum SelectedState {
            case selected
            case deselected(reason: ReturnReason?)
        }
        
        var name: String?
        var quantity: Int
        var price: Price
        var selectedState: SelectedState
        
        private enum ExtractedLineItemKey: String {
            case description, quantity, baseGross
        }
        
        init(name: String?, quantity: Int, price: Price, selectedState: SelectedState) {
            self.name = name
            self.quantity = quantity
            self.price = price
            self.selectedState = selectedState
            self._extractions = []
        }
        
        init(extractions: [Extraction]) throws {
            
            guard let extractedName = extractions.first(where: { $0.name == ExtractedLineItemKey.description.rawValue })?.value else {
                throw DigitalInvoiceParsingException.nameMissing
            }
            
            guard let extractedQuantity = extractions.first(where: { $0.name == ExtractedLineItemKey.quantity.rawValue })?.value else {
                throw DigitalInvoiceParsingException.quantityMissing
            }
            
            guard let extractedPrice = extractions.first(where: { $0.name == ExtractedLineItemKey.baseGross.rawValue })?.value else {
                throw DigitalInvoiceParsingException.priceMissing
            }
            
            guard let quantity = Int(extractedQuantity) else {
                throw DigitalInvoiceParsingException.cannotParseQuantity(string: extractedQuantity)
            }
            
            guard let price = Price(extractionString: extractedPrice) else {
                throw DigitalInvoiceParsingException.cannotParsePrice(string: extractedPrice)
            }
            
            self._extractions = extractions
            self.name = extractedName
            self.quantity = quantity
            self.price = price
            self.selectedState = .selected
        }
        
        private let _extractions: [Extraction]
        
        var extractions: [Extraction] {
            
            var modifiedExtractions: [Extraction] = _extractions.map { extraction in
                
                guard let extractionName = extraction.name,
                    let key = ExtractedLineItemKey(rawValue: extractionName) else {
                        return extraction
                }
                
                switch key {
                case .description:
                    extraction.value = name ?? ""
                case .quantity:
                    
                    switch selectedState {
                    case .selected:
                        extraction.value =  String(quantity)
                    case .deselected:
                        extraction.value = "0"
                    }
                    
                case .baseGross:
                    extraction.value = price.extractionString
                }
                
                return extraction
            }
            
            switch selectedState {
            case .deselected(let returnReason):
                if let returnReason = returnReason {
                    modifiedExtractions.append(Extraction(box: nil, candidates: nil, entity: "", value: returnReason.id, name: "returnReason"))
                }
            case .selected: break
            }
            
            return modifiedExtractions
        }
        
        var totalPrice: Price {
            return price * quantity
        }
    }
}

extension ReturnReason {
    
    var labelInLocalLanguageOrGerman: String {
        get {
            localizedLabels[Locale.current.languageCode ?? "de"] ?? localizedLabels["de"] ?? ""
        }
    }
}
