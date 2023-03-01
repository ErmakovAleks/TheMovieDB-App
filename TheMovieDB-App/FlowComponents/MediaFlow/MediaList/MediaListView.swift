//
//  MediaListView.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 28.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import UIKit

import RxSwift
import RxRelay

class MediaListView: BaseView<MediaListViewModel, MediaListViewModelOutputEvents>, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: -
    // MARK: Outlets
    
    @IBOutlet var mediaList: UITableView?
    
    // MARK: -
    // MARK: Variables
    
    private let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshTable(sender:)), for: .valueChanged)
        
        return refresh
    }()
    
    // MARK: -
    // MARK: Initializators
    
    init(viewModel: MediaListViewModel) {
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
        self.mediaList?.delegate = self
        self.mediaList?.dataSource = self
        self.mediaList?.refreshControl = self.refreshControl
        self.mediaList?.registerHeaderFooter(headerFooterClass: CustomTableViewHeader.self)
        self.mediaList?.registerCell(cellClass: MediaCollectionTableViewCell.self)
    }
    
    private func handler(events: MediaCollectionTableViewCellOutputEvents) {
        switch events {
        case .needFillWithMedia(let cell, let index, let id):
            let currentGenreMedia = self.viewModel.media[id]
            cell.fill(with: currentGenreMedia?[index])
        }
    }
    
    @objc private func refreshTable(sender: UIRefreshControl) {
        self.viewModel.genres = []
        self.viewModel.prepareInitialData()
        self.refreshControl.endRefreshing()
    }
    
    // MARK: -
    // MARK: Overrided
    
    override func prepareBindings(disposeBag: DisposeBag) {
        super.prepareBindings(disposeBag: disposeBag)
        
        self.viewModel.needUpdateTable
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.mediaList?.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: -
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.genres.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withHeaderFooterClass: CustomTableViewHeader.self)
        view.title.text  = self.viewModel.genres[section].name
        view.buttonHandler = {
            self.viewModel.showMoreBy(genre: self.viewModel.genres[section])
        }

           return view
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel?.textColor = .white
            view.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withCellClass: MediaCollectionTableViewCell.self, for: indexPath)
        
        let id = self.viewModel.genres[indexPath.section].id
        let onFirstSection = indexPath.section == 0
        
        let model = MediaTableViewCellModel(
            id: self.viewModel.genres[indexPath.section].id,
            numberOfItems: self.viewModel.media[id]?.count ?? 0,
            onFirstSection: onFirstSection) { [weak self] events in
                self?.handler(events: events)
            } onSelect: { [weak self] index, genreID in
                let genreMedia = self?.viewModel.media[genreID]
                if let id = genreMedia?[index].mediaID {
                    self?.viewModel.showDetail(by: id)
                }
            }
        
        cell.fill(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200.0
    }
}
