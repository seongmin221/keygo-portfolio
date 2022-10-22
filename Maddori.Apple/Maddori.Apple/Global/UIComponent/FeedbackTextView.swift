//
//  FeedbackTextView.swift
//  Maddori.Apple
//
//  Created by 김유나 on 2022/10/22.
//

import UIKit

import SnapKit

final class FeedbackTextView: UITextView {
    
    // MARK: - property
    
    var placeholder: String? {
        didSet { setupAttribute() }
    }
    
    // MARK: - life cycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configUI()
    }
    
    required init?(coder: NSCoder) { nil }
    
    private func configUI() {
        self.backgroundColor = .white300
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray100.cgColor
        self.font = .body1
        self.contentInset = .init(top: 10, left: 14, bottom: 10, right: 14)
        self.textColor = .gray500
        self.isScrollEnabled = false
    }
    
    // MARK: - func
    
    private func setupAttribute() {
        self.text = placeholder
    }
}
