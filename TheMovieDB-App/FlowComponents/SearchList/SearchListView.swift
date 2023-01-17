//
//  SearchListView.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 16.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

class SearchListView<Service: NetworkSessionProcessable>: BaseView<SearchListViewModel<Service>, SearchListViewModelOutputEvents>, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: -
    // MARK: Outlets
    
    @IBOutlet var searchList: UITableView?
    
    // MARK: -
    // MARK: Variables
    
    private var type: MediaType
    
    // MARK: -
    // MARK: Initializators
    
    init(viewModel: SearchListViewModel<Service>, type: MediaType) {
        self.type = type
        super.init(viewModel: viewModel)
        
        switch self.type {
        case .movie:
            self.title = "Movies"
        case .tv:
            self.title = "TV Shows"
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareTableView()
    }
    
    // MARK: -
    // MARK: Functions
    
    private func prepareTableView() {
        self.searchList?.delegate = self
        self.searchList?.dataSource = self
        self.searchList?.registerCell(cellClass: SearchTableViewCell.self)
    }
    
    // MARK: -
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withCellClass: SearchTableViewCell.self, for: indexPath)
        
        return cell
    }
}
