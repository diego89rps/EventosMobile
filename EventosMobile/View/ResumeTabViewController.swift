//
//  ResumeTabViewController.swift
//  EventosMobile
//
//  Created by Diego Ribeiro on 16/11/20.
//

import UIKit
import RxSwift
import RxCocoa

class ResumeTabViewController: UITabBarController, UITabBarControllerDelegate {
    
    var coordinator: MainCoordinator?
    let disposeBag = DisposeBag()
    
    let mainTab = ResumeViewController()
    let settingsTab = SettingsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupTabBar()
        bindInputs()
        setupTabBarLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
        addTabs()
    }
    
    private func setupTabBarLayout() {
        UITabBar.appearance().tintColor = .defaultColor(ColorName.defaultDarkBlue)
        
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]
        appearance.setTitleTextAttributes(attributes, for: .normal)
    }
    
    private func bindInputs() {
        mainTab.detailsCallback = {
            self.showDetails(with: $0)
        }
        
        settingsTab
            .customView
            .button
            .rx
            .tap
            .bind { [weak self] (_) in
                self?.showResgisterName()
            }.disposed(by: disposeBag)
        
        mainTab
            .customViewNoRegister
            .reloadBtn
            .rx
            .tap
            .bind { [weak self] (_) in
                self?.mainTab.loadRegisters()
            }.disposed(by: disposeBag)
    }
    
    private func showDetails(with index : Int) {
        self.coordinator?.goToDetails(with : mainTab.viewModel, index: index)
    }
    
    private func showResgisterName() {
        if settingsTab.viewModel.status() {
            settingsTab.viewModel.deleteRegister()
            settingsTab.viewDidAppear(true)
        } else {
            self.coordinator?.goToName()

        }
    }
    
    private func addTabs() {
        self.viewControllers = [mainTab, settingsTab]
    }
    
    private func setupTabBar() {
        setupTabOne()
        setupTabTwo()
    }
    
    private func setupNavigationController() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: Children tab(1)
    private func setupTabOne() {
        let item = UITabBarItem(title: "eventos",
                                image: UIImage(named: "resumeTabItem"),
                                selectedImage: UIImage(named: "resumeSelected"))
        mainTab.tabBarItem = item
    }
    
    // MARK: Notifications tab(2)
    private func setupTabTwo() {
        let item = UITabBarItem(title: "configurações", image: UIImage(named: "settingsTabItem"), selectedImage: UIImage(named: "settingsSelected"))
        settingsTab.tabBarItem = item
    }
    
}
