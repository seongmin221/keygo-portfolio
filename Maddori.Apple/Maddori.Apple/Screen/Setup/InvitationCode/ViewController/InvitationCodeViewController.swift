//
//  InvitedCodeViewController.swift
//  Maddori.Apple
//
//  Created by 이성호 on 2022/10/23.
//

import UIKit

import RxSwift

final class InvitationCodeViewController: BaseViewController {
    
    // MARK: - property
    
    private let invitationCodeView: InvitationCodeView = InvitationCodeView()
    
    private let viewModel: any BaseViewModelType
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - init
    
    init(viewModel: any BaseViewModelType) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle
    
    override func loadView() {
        view = invitationCodeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindUI()
    }
    
    // MARK: - override
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        configureNavigationController()
    }
    
    override func render() {
        setupToastView()
    }
    
    // MARK: - private func
    
    private func configureNavigationController() {
        guard let navigationController else { return }
        invitationCodeView.setupNavigationController(navigationController)
        invitationCodeView.setupNavigationItem(navigationItem)
    }
    
    private func setupToastView() {
        guard let navigationController else { return }
        invitationCodeView.setupToastView(navigationController)
    }
    
    private func bindViewModel() {
        let output = transformedOutput()
        bindOutputToViewModel(output)
    }
    
    private func transformedOutput() -> InvitationCodeViewModel.Output? {
        guard let viewModel = viewModel as? InvitationCodeViewModel else { return nil }
        let input = InvitationCodeViewModel.Input(viewDidLoad: Observable.just(()).asObservable())
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: InvitationCodeViewModel.Output?) {
        guard let output else { return }
        
        output.code
            .subscribe { [weak self] invitationCode in
                self?.invitationCodeView.updateInvitationCode(code: invitationCode)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        guard let navigationController else { return }
        
        invitationCodeView.copyCodeButtonTapPublisher
            .subscribe { [weak self] _ in
                self?.invitationCodeView.showToast(navigationController: navigationController)
            }
            .disposed(by: disposeBag)
        
        invitationCodeView.startButtonTapPublisher
            .subscribe { [weak self] _ in
                self?.pushHomeViewController()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Helper

extension InvitationCodeViewController {
    private func pushHomeViewController() {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.changeRootViewCustomTabBarView()
    }
}
