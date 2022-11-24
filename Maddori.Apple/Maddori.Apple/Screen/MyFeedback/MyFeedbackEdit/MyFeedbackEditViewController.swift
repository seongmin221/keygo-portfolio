//
//  EditFeedbackFromMeViewController.swift
//  Maddori.Apple
//
//  Created by 김유나 on 2022/11/06.
//

import UIKit

import Alamofire
import SnapKit

final class MyFeedbackEditViewController: AddFeedbackViewController {
    private var feedbackType: FeedBackDTO
    private let feedbackDetail: FeedbackFromMeModel
    private var isStartSwitchToggleChanged: Bool = false {
        didSet {
            if !(isTextInputChanged() || isFeedbackTypeChanged || isStartSwitchToggleChanged) {
                super.feedbackDoneButton.isDisabled = true
            } else {
                super.feedbackDoneButton.isDisabled = false
            }
        }
    }
    private var isFeedbackTypeChanged: Bool = false {
        didSet {
            if !(isTextInputChanged() || isFeedbackTypeChanged || isStartSwitchToggleChanged) {
                super.feedbackDoneButton.isDisabled = true
            } else {
                super.feedbackDoneButton.isDisabled = false
            }
        }
    }
    
    // MARK: - life cycle
    
    init(feedbackDetail: FeedbackFromMeModel) {
        self.feedbackDetail = feedbackDetail
        self.feedbackType = FeedBackDTO.init(rawValue: feedbackDetail.feedbackType.rawValue) ?? .continueType
        super.init(to: feedbackDetail.nickname, toUserId: 0, reflectionId: feedbackDetail.reflectionId)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFeedbackType()
        setupFeedbackKeyword()
        setupFeedbackContent()
        setupFeedbackStart()
        hideEditFeedbackUntilLabel()
        detectChangeOfFeedbackType()
        setupNavigationLeftItem()
    }
    
    // MARK: - func
    
    private func setupFeedbackType() {
        switch feedbackDetail.feedbackType {
        case .continueType:
            super.feedbackTypeButtonView.touchUpToSelectType(.continueType)
        case .stopType:
            super.feedbackTypeButtonView.touchUpToSelectType(.stopType)
        }
    }
    
    private func setupFeedbackKeyword() {
        super.feedbackKeywordTextField.text = feedbackDetail.keyword
        super.setCounter(count: feedbackDetail.keyword.count)
    }
    
    private func setupFeedbackContent() {
        super.feedbackContentTextView.text = feedbackDetail.info
        super.feedbackContentTextView.textColor = .black100
    }
    
    private func setupFeedbackStart() {
        if let start = feedbackDetail.start {
            if !start.isEmpty {
                super.feedbackStartSwitch.isOn = true
                super.feedbackStartTextViewLabel.isHidden = false
                super.feedbackStartTextView.isHidden = false
                super.feedbackStartTextView.text = start
                super.feedbackStartTextView.textColor = .black100
            }
        }
        super.feedbackStartSwitchBottomEqualToSuperView?.constraint.deactivate()
        super.feedbackStartTextView.snp.remakeConstraints {
            $0.top.equalTo(feedbackStartTextViewLabel.snp.bottom).offset(SizeLiteral.labelComponentPadding)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
            $0.height.equalTo(150)
            $0.bottom.equalToSuperview().inset(80)
        }
    }
    
    private func hideEditFeedbackUntilLabel() {
        super.editFeedbackUntilLabel.isHidden = true
        super.feedbackDoneButtonView.snp.remakeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(95)
        }
    }
    
    private func notChangedStartContent() -> Bool {
        if let start = self.feedbackDetail.start {
            if super.feedbackStartTextView.text == TextLiteral.addFeedbackViewControllerStartTextViewPlaceholder {
                return true
            } else {
                if super.feedbackStartTextView.text == start {
                    return true
                } else {
                    return false
                }
            }
        } else {
            if super.feedbackStartTextView.text == TextLiteral.addFeedbackViewControllerStartTextViewPlaceholder || super.feedbackStartTextView.text.isEmpty {
                return true
            } else {
                return false
            }
        }
    }
    
    private func isTextInputChanged() -> Bool {
        if super.feedbackContentTextView.text == feedbackDetail.info &&
            notChangedStartContent() &&
            super.feedbackKeywordTextField.text == feedbackDetail.keyword {
            return false
        } else {
            return true
        }
    }
    
    private func detectChangeOfFeedbackType() {
        super.feedbackTypeButtonView.changeFeedbackType = { [weak self] type in
            guard let feedbackType = FeedBackDTO.init(rawValue: type.rawValue) else { return }
            if type == self?.feedbackDetail.feedbackType {
                self?.isFeedbackTypeChanged = false
                self?.feedbackType = feedbackType
            } else {
                self?.isFeedbackTypeChanged = true
                self?.feedbackType = feedbackType
            }
        }
    }
    
    private func setupNavigationLeftItem() {
        super.backButton.isHidden = true
    }
    
    override func didTappedDoneButton() {
        let dto = EditFeedBackDTO(type: feedbackType,
                                  keyword: super.feedbackKeywordTextField.text ?? "",
                                  content: super.feedbackContentTextView.text ?? "",
                                  start_content: super.feedbackStartSwitch.isOn ? super.feedbackStartTextView.text ?? "" : "")
        putEditFeedBack(type: .putEditFeedBack(reflectionId: feedbackDetail.reflectionId, feedBackId: feedbackDetail.feedbackId, dto))
    }
    
    override func didTappedCloseButton() {
        // FIXME: - X 버튼이 아닌 뒤로가기 버튼이라던지 수정이 필요함
        navigationController?.popViewController(animated: true)
    }
    
    override func didTappedSwitch() {
        super.didTappedSwitch()
        if let start = self.feedbackDetail.start {
            let hasStart = !start.isEmpty
            if hasStart != super.feedbackStartSwitch.isOn {
                isStartSwitchToggleChanged = true
            } else {
                isStartSwitchToggleChanged = false
            }
        } else {
            if super.feedbackStartSwitch.isOn {
                isStartSwitchToggleChanged = true
            }
        }
    }
    
    // MARK: - selector
    
    @objc override func willHideKeyboard(notification: NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            super.feedbackDoneButtonView.transform = .identity
        })
        super.editFeedbackUntilLabel.isHidden = true
    }
    
    // MARK: - api
    
    private func putEditFeedBack(type: MyFeedBackEndPoint<EditFeedBackDTO>) {
        AF.request(type.address,
                   method: type.method,
                   parameters: type.body,
                   encoder: JSONParameterEncoder.default,
                   headers: type.headers
        ).responseDecodable(of: BaseModel<EditFeedBackResponse>.self) { json in
            if let _ = json.value {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    // MARK: - extension
    
    override func textFieldDidChangeSelection(_ textField: UITextField) {
        super.setCounter(count: textField.text?.count ?? 0)
        super.checkMaxLength(textField: super.feedbackKeywordTextField, maxLength: Length.keywordMaxLength)
        super.feedbackDoneButton.isDisabled = !(isTextInputChanged() || isFeedbackTypeChanged)
    }
    
    override func textViewDidChangeSelection(_ textView: UITextView) {
        super.feedbackDoneButton.isDisabled = !(isTextInputChanged() || isFeedbackTypeChanged)
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
