//
//  BaseView.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 23.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import Foundation
import UIKit

import RxSwift
import RxCocoa

public class BaseView<ViewModelType, OutputEventsType>: UIViewController
where ViewModelType: BaseViewModel<OutputEventsType>, OutputEventsType: Events
{
    // MARK: -
    // MARK: Accesors
    
    public var events: Observable<OutputEventsType> {
        return self.viewModel.events
    }
    
    internal let viewModel: ViewModelType
    
    private let disposeBag = DisposeBag()
    
    // MARK: -
    // MARK: Initializations
    
    public init(viewModel: ViewModelType, nibName: String? = nil, bundle: Bundle? = nil) {
        self.viewModel = viewModel
        let nibName = nibName ?? String(describing: Self.self).components(separatedBy: "<").first
        
        super.init(nibName: nibName, bundle: bundle ?? Bundle(for: Self.self))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: ViewController Life Cylce
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareBindings(disposeBag: self.disposeBag)
        self.prepare(with: self.viewModel)
        self.viewModel.viewDidLoaded()
        self.gradientBackground()
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    // MARK: -
    // MARK: View Settings
    
    private func gradientBackground() {
        lazy var gradient: CAGradientLayer = {
            let gradient = CAGradientLayer()
            gradient.type = .axial
            gradient.colors = [
                Colors.gradientTop.cgColor,
                Colors.gradientBottom.cgColor
            ]
            gradient.locations = [0, 1]
            return gradient
        }()
        
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    //MARK: -
    //MARK: Overrding methods
    
    func prepareBindings(disposeBag: DisposeBag) {
        
    }
    
    func prepare(with viewModel: ViewModelType) {
        
    }
}
