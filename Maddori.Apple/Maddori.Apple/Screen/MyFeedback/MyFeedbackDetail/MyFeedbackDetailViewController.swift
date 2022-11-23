//
//  FeedbackFromMeDetailViewController.swift
//  Maddori.Apple
//
//  Created by 김유나 on 2022/11/02.
//

import UIKit

import SnapKit

final class MyFeedbackDetailViewController: BaseViewController {
    
    // FIXME: - 추후 API 연결 (현재는 mock data)
    
    private let model = FeedbackFromMeModel.mockData
    private let reflectionDate: Date? = nil
    
    // MARK: - property
    
    private let backButton = BackButton(type: .system)
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextLiteral.myFeedbackDetailViewControllerDeleteButtonText, for: .normal)
        button.setTitleColor(.red100, for: .normal)
        button.titleLabel?.font = .label2
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        let action = UIAction { [weak self] _ in
            self?.showAlertView(type: .delete, navigationViewController: self?.navigationController)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    private let feedbackFromMeDetailScrollView = UIScrollView()
    private let feedbackFromMeDetailContentView = UIView()
    private lazy var feedbackFromMeDetailTitleLabel: UILabel = {
        let label = UILabel()
        label.setTitleFont(text: model.nickname + TextLiteral.myFeedbackDetailViewControllerTitleLabel)
        label.textColor = .black100
        return label
    }()
    private let feedbackTypeLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.feedbackTypeLabel
        label.textColor = .black100
        label.font = .label2
        return label
    }()
    private lazy var feedbackTypeText: UILabel = {
        let label = UILabel()
        label.text = model.feedbackType.rawValue
        label.textColor = .gray400
        label.font = .body1
        return label
    }()
    private let feedbackKeywordLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.feedbackKeywordLabel
        label.textColor = .black100
        label.font = .label2
        return label
    }()
    private lazy var feedbackKeywordText: UILabel = {
        let label = UILabel()
        label.setTextWithLineHeight(text: model.keyword, lineHeight: 24)
        label.textColor = .gray400
        label.font = .body1
        return label
    }()
    private let feedbackContentLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.feedbackContentLabel
        label.textColor = .black100
        label.font = .label2
        return label
    }()
    private lazy var feedbackContentText: UILabel = {
        let label = UILabel()
        label.setTextWithLineHeight(text: model.info, lineHeight: 24)
        label.textColor = .gray400
        label.font = .body1
        label.numberOfLines = 0
        return label
    }()
    private let feedbackStartLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.myFeedbackDetailViewControllerFeedbackStartLabel
        label.textColor = .black100
        label.font = .label2
        return label
    }()
    private lazy var feedbackStartText: UILabel = {
        let label = UILabel()
        label.setTextWithLineHeight(text: model.start, lineHeight: 24)
        label.textColor = .gray400
        label.font = .body1
        label.numberOfLines = 0
        return label
    }()
    private let feedbackEditButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .white200
        return view
    }()
    private lazy var editFeedbackUntilLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.myFeedbackDetailViewControllerBeforeReflectionLabel
        label.textColor = .gray400
        label.font = .body2
        return label
    }()
    private lazy var feedbackEditButton: MainButton = {
        let button = MainButton()
        button.title = TextLiteral.myFeedbackDetailViewControllerEditButtonText
        button.isDisabled = false
        return button
    }()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCloseButton()
        setupMainButton()
    }
    
    override func configUI() {
        super.configUI()
        setupFeedbackSendTimeLabel()
        setupOptionalComponents()
    }
    
    override func render() {
        view.addSubview(feedbackFromMeDetailScrollView)
        feedbackFromMeDetailScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        feedbackFromMeDetailScrollView.addSubview(feedbackFromMeDetailContentView)
        feedbackFromMeDetailContentView.snp.makeConstraints {
            $0.edges.equalTo(feedbackFromMeDetailScrollView.snp.edges)
            $0.width.equalTo(feedbackFromMeDetailScrollView.snp.width)
            $0.height.equalTo(view.frame.height)
        }
        
        feedbackFromMeDetailContentView.addSubview(feedbackFromMeDetailTitleLabel)
        feedbackFromMeDetailTitleLabel.snp.makeConstraints {
            $0.top.equalTo(feedbackFromMeDetailContentView).inset(SizeLiteral.topPadding)
            $0.leading.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
        }
        
        feedbackFromMeDetailContentView.addSubview(feedbackTypeLabel)
        feedbackTypeLabel.snp.makeConstraints {
            $0.top.equalTo(feedbackFromMeDetailTitleLabel.snp.bottom).offset(SizeLiteral.topComponentPadding)
            $0.leading.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
        }
        
        feedbackFromMeDetailContentView.addSubview(feedbackTypeText)
        feedbackTypeText.snp.makeConstraints {
            $0.top.equalTo(feedbackTypeLabel.snp.bottom).offset(SizeLiteral.labelComponentPadding)
            $0.leading.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
        }
        
        feedbackFromMeDetailContentView.addSubview(feedbackKeywordLabel)
        feedbackKeywordLabel.snp.makeConstraints {
            $0.top.equalTo(feedbackTypeText.snp.bottom).offset(SizeLiteral.componentIntervalPadding)
            $0.leading.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
        }
        
        feedbackFromMeDetailContentView.addSubview(feedbackKeywordText)
        feedbackKeywordText.snp.makeConstraints {
            $0.top.equalTo(feedbackKeywordLabel.snp.bottom).offset(SizeLiteral.labelComponentPadding)
            $0.leading.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
        }
        
        feedbackFromMeDetailContentView.addSubview(feedbackContentLabel)
        feedbackContentLabel.snp.makeConstraints {
            $0.top.equalTo(feedbackKeywordText.snp.bottom).offset(SizeLiteral.componentIntervalPadding)
            $0.leading.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
        }
        
        feedbackFromMeDetailContentView.addSubview(feedbackContentText)
        feedbackContentText.snp.makeConstraints {
            $0.top.equalTo(feedbackContentLabel.snp.bottom).offset(SizeLiteral.labelComponentPadding)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
        }
        
        feedbackFromMeDetailContentView.addSubview(feedbackStartLabel)
        feedbackStartLabel.snp.makeConstraints {
            $0.top.equalTo(feedbackContentText.snp.bottom).offset(SizeLiteral.componentIntervalPadding)
            $0.leading.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
        }
        
        feedbackFromMeDetailContentView.addSubview(feedbackStartText)
        feedbackStartText.snp.makeConstraints {
            $0.top.equalTo(feedbackStartLabel.snp.bottom).offset(SizeLiteral.labelComponentPadding)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
        }
        
        // FIXME: - layout 수정필요
        view.addSubview(feedbackEditButtonView)
        feedbackEditButtonView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(134)
        }
        
        feedbackEditButtonView.addSubview(feedbackEditButton)
        feedbackEditButton.snp.makeConstraints {
            $0.bottom.equalTo(feedbackEditButtonView.snp.bottom).inset(44)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
        }
        
        feedbackEditButtonView.addSubview(editFeedbackUntilLabel)
        editFeedbackUntilLabel.snp.makeConstraints {
            $0.bottom.equalTo(feedbackEditButton.snp.top).offset(-11)
            $0.centerX.equalTo(feedbackEditButtonView.snp.centerX)
        }
    }
    
    // MARK: - func
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        let button = removeBarButtonItemOffset(with: backButton, offsetX: 10)
        let backButton = makeBarButtonItem(with: button)
        let deleteButton = makeBarButtonItem(with: deleteButton)
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = deleteButton
    }
    
    private func setupFeedbackSendTimeLabel() {
        if let date = reflectionDate {
            if date <= Date() {
                feedbackEditButton.isHidden = true
                deleteButton.isHidden = true
                editFeedbackUntilLabel.setTextWithLineHeight(text: TextLiteral.myFeedbackDetailViewControllerReflectionIsStartedLabel, lineHeight: 22)
                editFeedbackUntilLabel.snp.remakeConstraints {
                    $0.bottom.equalTo(feedbackEditButtonView.snp.bottom).inset(44)
                    $0.centerX.equalTo(feedbackEditButtonView.snp.centerX)
                }
            } else {
                editFeedbackUntilLabel.setTextWithLineHeight(text: TextLiteral.myFeedbackDetailViewControllerBeforeReflectionLabel, lineHeight: 22)
            }
        }
    }

    private func setupOptionalComponents() {
        if model.start == nil {
            feedbackStartLabel.isHidden = true
            feedbackStartText.isHidden = true
        }
    }
    
    // MARK: - setup
    
    private func setupCloseButton() {
        let action = UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        backButton.addAction(action, for: .touchUpInside)
    }
    
    private func setupMainButton() {
        let action = UIAction { [weak self ] _ in
            // FIXME: - 내 데이터는 유저디폴트로 변경
            self?.navigationController?.pushViewController(MyFeedbackEditViewController(to: "케미", toUserId: 0, reflectionId: 0), animated: true)
        }
        feedbackEditButton.addAction(action, for: .touchUpInside)
    }
}