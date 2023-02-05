//
//  FavoritesListView.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 03.02.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

import RxSwift
import RxRelay

class FavoritesListView: BaseView<FavoritesListViewModel, FavoritesListViewModelOutputEvents>, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: -
    // MARK: Outlets
    
    @IBOutlet var favoritesList: UITableView?
    
    // MARK: -
    // MARK: Initializators
    
    init(viewModel: FavoritesListViewModel) {
        super.init(viewModel: viewModel)
        
        self.title = self.viewModel.tabTitle
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: -
    // MARK: ViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareTableView()
    }

    // MARK: -
    // MARK: Functions

    private func prepareTableView() {
        self.favoritesList?.delegate = self
        self.favoritesList?.dataSource = self
        self.favoritesList?.registerCell(cellClass: SearchTableViewCell.self)
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
    // MARK: Overrided
    
    override func prepareBindings(disposeBag: DisposeBag) {
        super.prepareBindings(disposeBag: disposeBag)
        
        self.viewModel.needReloadTable.bind { [weak self] _ in
            self?.favoritesList?.reloadData()
        }
        
        self.viewModel.needReload = { self.favoritesList?.reloadData() }
    }
    
    // MARK: -
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("<!> favorites.count = \(self.viewModel.favorites.count)")
        return self.viewModel.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withCellClass: SearchTableViewCell.self, for: indexPath)
        let item = self.viewModel.favorites[indexPath.row]
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
}
