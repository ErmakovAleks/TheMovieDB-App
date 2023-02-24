//
//  GenreMediaListView.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 19.02.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

import RxSwift
import RxRelay

class GenreMediaListView:
    BaseView<GenreMediaListViewModel, GenreMediaListViewModelOutputEvents>,
    UITableViewDataSource,
    UITableViewDelegate,
    UIScrollViewDelegate
{
    
    // MARK: -
    // MARK: Outlets
    
    @IBOutlet var mediaList: UITableView?
    
    // MARK: -
    // MARK: View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareTableView()
    }
    
    // MARK: -
    // MARK: Functions
    
    private func prepareTableView() {
        self.mediaList?.delegate = self
        self.mediaList?.dataSource = self
        self.mediaList?.registerCell(cellClass: SearchTableViewCell.self)
    }
    
    private func handler(events: SearchTableViewCellModelOutputEvents) {
        switch events {
        case .needLoadPoster(let url, let posterView, let spinner):
            self.viewModel.fetchPoster(endPath: url) { image in
                posterView?.image = image
                spinner?.stopAnimating()
                spinner?.isHidden = true
            }
        }
    }
    
    // MARK: -
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.mediaResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withCellClass: SearchTableViewCell.self, for: indexPath)
        let item = self.viewModel.mediaResults[indexPath.row]
        let model = SearchTableViewCellModel(
            mediaTitle: item.mediaTitle,
            mediaPoster: item.mediaPoster,
            mediaOverview: item.mediaOverview,
            mediaReleaseDate: item.mediaDescription) { events in
                self.handler(events: events)
            }
        
        cell.fill(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.showDetail(by: indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !self.viewModel.isLoadingList){
            self.viewModel.isLoadingList = true
            self.viewModel.loadMoreItemsForList()
        }
    }
    
    // MARK: -
    // MARK: Overrided
    
    override func prepareBindings(disposeBag: DisposeBag) {
        self.viewModel.needReloadTable = {
            DispatchQueue.main.async {
                self.mediaList?.reloadData()
                self.viewModel.isLoadingList = false
            }
        }
    }
}
