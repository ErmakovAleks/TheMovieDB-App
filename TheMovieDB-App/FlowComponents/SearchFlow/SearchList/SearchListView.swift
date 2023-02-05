//
//  SearchListView.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 16.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

import RxSwift
import RxRelay

class SearchListView: BaseView<SearchListViewModel, SearchListViewModelOutputEvents>, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: -
    // MARK: Outlets
    
    @IBOutlet var searchList: UITableView?
    
    // MARK: -
    // MARK: Initializators
    
    init(viewModel: SearchListViewModel) {
        super.init(viewModel: viewModel)
        
        self.title = self.viewModel.tabTitle
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
    
    private func handler(events: SearchTableViewCellModelOutputEvents) {
        switch events {
        case .needLoadPoster(let url, let posterView):
            self.viewModel.fetchPoster(endPath: url) { data in
                guard let data else { return }
                posterView?.image = UIImage(data: data)
            }
        }
    }
    
    // MARK: -
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.mediaResults.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withCellClass: SearchTableViewCell.self, for: indexPath)
        let item = self.viewModel.mediaResults.value[indexPath.row]
        let model = SearchTableViewCellModel(
            mediaTitle: item.mediaTitle,
            mediaPoster: item.mediaPoster,
            mediaOverview: item.mediaOverview) { events in
                self.handler(events: events)
            }
        
        cell.fill(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.showDetail(by: indexPath.row)
    }
    
    // MARK: -
    // MARK: Overrided
    
    override func prepareBindings(disposeBag: DisposeBag) {
        self.viewModel.mediaResults.bind { [weak self] _ in
            self?.searchList?.reloadData()
        }
    }
}
