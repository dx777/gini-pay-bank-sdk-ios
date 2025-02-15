//
//  DigitalInvoiceHeaderView.swift
//  GiniPayBank
//
//  Created by Maciej Trybilo on 20.11.19.
//

import UIKit

class DigitalInvoiceHeaderCell: UITableViewCell {
    
    private var secondaryMessageLabel: UILabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var returnAssistantConfiguration: ReturnAssistantConfiguration? {
        didSet {
            setup()
        }
    }
    
    private func setup() {
        
        let topSpacerView = UIView()
        topSpacerView.translatesAutoresizingMaskIntoConstraints = false
        topSpacerView.heightAnchor.constraint(equalToConstant: 8).isActive = true
        topSpacerView.backgroundColor = .clear
        
        selectionStyle = .none
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        let messageAttributedString = NSMutableAttributedString(string: String.ginipayLocalized(resource: DigitalInvoiceStrings.headerMessagePrimary))
        
        messageAttributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                             value: paragraphStyle,
                                             range: NSRange(location: 0, length: messageAttributedString.length))
        
        messageLabel.attributedText = messageAttributedString
        
        messageLabel.numberOfLines = 0
        messageLabel.font = returnAssistantConfiguration?.customFont.regular ?? ReturnAssistantConfiguration.shared.customFont.regular
        messageLabel.textAlignment = .center
        let messageSpacerView = UIView()
        messageSpacerView.translatesAutoresizingMaskIntoConstraints = false
        messageSpacerView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        messageSpacerView.backgroundColor = .clear
        let secondaryMessageAttributedString =
            NSMutableAttributedString(string: .ginipayLocalized(resource: DigitalInvoiceStrings.headerMessageSecondary))

        secondaryMessageAttributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: secondaryMessageAttributedString.length))
        
        let secondaryMessageLabel = UILabel()
        secondaryMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryMessageLabel.attributedText = secondaryMessageAttributedString
        secondaryMessageLabel.numberOfLines = 0
        secondaryMessageLabel.font = returnAssistantConfiguration?.digitalInvoiceSecondaryMessageTextFont ??
            ReturnAssistantConfiguration.shared.digitalInvoiceSecondaryMessageTextFont
        secondaryMessageLabel.textColor = returnAssistantConfiguration?.digitalInvoiceSecondaryMessageTextColor ??
            ReturnAssistantConfiguration.shared.digitalInvoiceSecondaryMessageTextColor
        secondaryMessageLabel.textAlignment = .center
        
        self.secondaryMessageLabel = secondaryMessageLabel
        
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        spacerView.backgroundColor = .clear
        
        let imageView = UIImageView(image: UIImage(named: "invoiceIllustration",
                                                   in: giniPayBankBundle(),
                                                   compatibleWith: nil))
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 153).isActive = true
        imageView.contentMode = .scaleAspectFit
        
        let spacerView1 = UIView()
        spacerView1.translatesAutoresizingMaskIntoConstraints = false
        spacerView1.heightAnchor.constraint(equalToConstant: 15).isActive = true
        spacerView1.backgroundColor = .clear
        
        let stackView = UIStackView(arrangedSubviews: [topSpacerView,
                                                       messageLabel,
                                                       messageSpacerView,
                                                       secondaryMessageLabel,
                                                       spacerView,
                                                       imageView,
                                                       spacerView1])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        
        contentView.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        backgroundColor = UIColor.from(giniColor: returnAssistantConfiguration?.digitalInvoiceBackgroundColor ?? ReturnAssistantConfiguration.shared.digitalInvoiceBackgroundColor)
    }
}
