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
        
        self.mediaList?
            .register(CustomTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
//        self.mediaList?.registerHeaderFooter(headerFooterClass: CustomTableViewHeader.self)
        self.mediaList?.registerCell(cellClass: CollectionTableViewCell.self)
    }
    
    // MARK: -
    // MARK: Overrided
    
    override func prepareBindings(disposeBag: DisposeBag) {
        self.viewModel.media
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.mediaList?.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: -
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.genres.value.count + 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                       "sectionHeader") as? CustomTableViewHeader
        //let view = tableView.dequeueReusableHeaderFooterView(withHeaderFooterClass: CustomTableViewHeader.self)
        view?.title.text = section != 0
            ? self.viewModel.genres.value[section - 1].name
            : self.viewModel.trendTitle

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
        let cell = tableView.dequeueReusableCell(withCellClass: CollectionTableViewCell.self, for: indexPath)
        cell.viewModel = self.viewModel
        
        if indexPath.section == 0 {
            cell.onFirstSection = true
            cell.collectionView?.reloadData()
        } else {
            let id = self.viewModel.genres.value[indexPath.section - 1].id
            cell.fill(by: id)
        }
        
        cell.onSelect = { id in
            self.viewModel.showDetail(by: id)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200.0
    }
}
