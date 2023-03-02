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
    @IBOutlet var placeholderView: UIView?
    
    // MARK: -
    // MARK: Variables
    
    public var isNeedReload: Bool = false
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isNeedReload {
            self.viewModel.fetchFavorites()
            self.favoritesList?.reloadData()
            self.isNeedReload = false
        }
    }
    
    // MARK: -
    // MARK: Functions

    private func prepareTableView() {
        self.favoritesList?.delegate = self
        self.favoritesList?.dataSource = self
        self.favoritesList?.registerCell(cellClass: FavoritesListTableViewCell.self)
    }
    
    // MARK: -
    // MARK: Overrided
    
    override func prepareBindings(disposeBag: DisposeBag) {
        super.prepareBindings(disposeBag: disposeBag)
        
        self.viewModel.needReloadTable.bind { [weak self] in
            if !(self?.viewModel.favorites.isEmpty ?? true) {
                self?.favoritesList?.isHidden = false
                self?.favoritesList?.reloadData()
                self?.placeholderView?.isHidden = true
            } else {
                self?.favoritesList?.isHidden = true
                self?.placeholderView?.isHidden = false
            }
            
        }
        .disposed(by: disposeBag)
    }
    
    // MARK: -
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withCellClass: FavoritesListTableViewCell.self, for: indexPath)
        let item = self.viewModel.favorites[indexPath.row]
        let model = FavoritesTableViewCellModel(
            mediaTitle: item.mediaTitle,
            mediaPoster: item.mediaPoster,
            mediaOverview: item.mediaOverview,
            mediaID: item.mediaID) { events in
                self.viewModel.handler(events: events)
            } removeHandler: {
                self.viewModel.removeFromFavorites(
                    mediaID: item.mediaID,
                    type: self.viewModel.type
                )
                
                self.viewModel.favorites.removeAll { $0.mediaID == item.mediaID }
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        
        cell.fill(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.showDetail(by: indexPath.row)
    }
}
