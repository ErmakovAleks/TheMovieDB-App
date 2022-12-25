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
        
        super.init(nibName: nibName, bundle: bundle ?? Bundle(for: Self.self))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModel: ViewModelType) {
        let bundle = Bundle(for: Self.self)
        
        self.init(viewModel: viewModel, bundle: bundle)
    }
    
    // MARK: -
    // MARK: ViewController Life Cylce
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareBindings(disposeBag: self.disposeBag)
        self.prepare(with: self.viewModel)
        self.viewModel.viewDidLoaded()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ///  show bottom bar only for root vc in current navigation stack
        let isRootController = self.navigationController?.viewControllers.first === self
        self.tabBarController?.tabBar.isHidden = !isRootController
    }
    
    //MARK: -
    //MARK: Overrding methods
    
    func prepareBindings(disposeBag: DisposeBag) {
        
    }
    
    func prepare(with viewModel: ViewModelType) {
        
    }
}
