//
//  SearchView.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 23.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

import RxSwift
import RxCocoa

class SearchView: BaseView<SearchViewModel, SearchViewModelOutputEvents> {
    
    // MARK: -
    // MARK: Outlets
    
    @IBOutlet var controlStack: UIStackView?
    @IBOutlet var indicatorContainerView: UIView?
    @IBOutlet var containerView: UIView?
    
    // MARK: -
    // MARK: Variables
    
    private var indicatorView = UIView()
    private var activeTabIndex = 0
    
    // MARK: -
    // MARK: ViewController Life Cycle

    override func viewDidLoad() {
        self.prepareControllers()
        self.prepareNavigationBar()
        self.prepareIndicator()
        
        super.viewDidLoad()
    }
    
    // MARK: -
    // MARK: Private fuctions
    
    private func prepareControllers() {
        self.prepareStack()
    }
    
    private func prepareNavigationBar() {
        self.title = "Search"
        let searchController = UISearchController()
        searchController.searchBar.searchTextField.backgroundColor = Colors.gradientBottom
        self.navigationItem.searchController = searchController
        let textField =
        self.navigationItem.searchController?.searchBar.value(forKey: "searchField") as? UITextField
        textField?.textColor = .white
    }
    
    private func prepareIndicator() {
        self.indicatorView.backgroundColor = .white
        self.indicatorView.frame = CGRect(
            x: 0,
            y: 0,
            width: (Int(self.indicatorContainerView?.frame.width ?? 0) / (self.controlStack?.arrangedSubviews.count ?? 1)),
            height: Int(self.indicatorContainerView?.frame.height ?? 0)
        )
        self.indicatorContainerView?.addSubview(self.indicatorView)
        
    }
    
    private func prepareStack() {
        self.viewModel.childViewControllers.forEach { controller in
            let button = UIButton()
            button.backgroundColor = UIColor.clear
            button.setTitle(controller.title, for: .normal)
            button.addTarget(self, action: #selector(self.showController), for: .touchUpInside)
            self.controlStack?.addArrangedSubview(button)
        }
        
        if let controller = self.viewModel.childViewControllers.first {
            self.addChildController(controller)
        }
    }
    
    private func addChildController(_ controller: UIViewController) {
        addChild(controller)
        self.containerView?.addSubview(controller.view)
        controller.view.frame = self.containerView?.bounds ?? CGRect.zero
        controller.didMove(toParent: self)
    }
    
    private func select(numberOfButton: Int?) {
        guard let number = numberOfButton else { return }
        
        let width = CGFloat(self.indicatorContainerView?.frame.width ?? 0.0) / CGFloat(self.controlStack?.arrangedSubviews.count ?? 1)
        let point = CGPoint(x: number * Int(width), y: 0)
        let railHeight = self.indicatorContainerView?.frame.height ?? 0
        
        let origin = CGPoint(x: point.x, y: point.y)
        let size = CGSize(width: width, height: railHeight)
        
        UIView.animate(
            withDuration: 0.35,
            delay: 0,
            options: [.beginFromCurrentState, .curveEaseInOut, .allowUserInteraction],
            animations: {
                self.indicatorView.frame = CGRect(origin: origin, size: size)
            }
        )
    }
    
    @objc func showController(_ sender: UIButton) {
        self.children.forEach { child in
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        
        self.viewModel.childViewControllers.enumerated().forEach { index, controller in
            if controller.title == sender.currentTitle {
                self.activeTabIndex = index
                self.addChildController(controller)
                self.select(numberOfButton: index)
                
                if let text = self.navigationItem.searchController?.searchBar.text, !text.isEmpty {
                    self.viewModel.searchOf(text: text, of: MediaType.type(by: index))
                } else {
                    self.viewModel.mediaResults.accept([])
                }
            }
        }
    }
    
    // MARK: -
    // MARK: Overrided
    
    override func prepareBindings(disposeBag: DisposeBag) {
        self.navigationItem.searchController?.searchBar.rx.text
            .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .bind { [weak self] text in
                guard let text, let tabIndex = self?.activeTabIndex else { return }
                if !text.isEmpty {
                    self?.viewModel.searchOf(text: text, of: MediaType.type(by: tabIndex))
                } else {
                    self?.viewModel.mediaResults.accept([])
                }
            }
            .disposed(by: disposeBag)
        
        self.viewModel.mediaResults.bind { [weak self] results in
            if let child = self?.children.first as? SearchListView {
                child.viewModel.mediaResults.accept(results)
                child.searchList?.reloadData()
            }
        }
        .disposed(by: disposeBag)
    }
}
