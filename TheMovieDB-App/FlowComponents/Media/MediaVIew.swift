//
//  MediaView.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 10.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

class MediaView: BaseView<MediaViewModel, MediaViewModelOutputEvents> {
    
    // MARK: -
    // MARK: Outlets
    
    @IBOutlet var controlStack: UIStackView?
    @IBOutlet var indicatorContainerView: UIView?
    @IBOutlet var containerView: UIView?
    
    // MARK: -
    // MARK: Variables
    
    private var indicatorView = UIView()
    
    // MARK: -
    // MARK: ViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareControllers()
        self.prepareNavigationBar()
        self.prepareIndicator()
    }
    
    // MARK: -
    // MARK: Private fuctions
    
    private func prepareControllers() {
        self.prepareStack()
    }
    
    private func prepareNavigationBar() {
        self.navigationItem.title = "Media"
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
                self.addChildController(controller)
                self.select(numberOfButton: index)
            }
        }
    }
}
