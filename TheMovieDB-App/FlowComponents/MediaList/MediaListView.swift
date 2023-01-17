//
//  MediaListView.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 28.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import UIKit

import RxSwift
import RxRelay

class MediaListView<Service: NetworkSessionProcessable>: BaseView<MediaListViewModel<Service>, MediaListViewModelOutputEvents>, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: -
    // MARK: Outlets
    
    @IBOutlet var moviesList: UITableView?
    @IBOutlet var segmentControl: CustomSegmentControl?
    
    // MARK: -
    // MARK: Variables
    
    private var posters: [UIImage?] = []
    
    // MARK: -
    // MARK: ViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareTitle()
        self.prepareTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.gradientBackground()
    }
    
    // MARK: -
    // MARK: Functions
    
    private func prepareTitle() {
        self.title = "Movies"
        self.navigationController?.navigationBar.titleTextAttributes =
        [
            NSAttributedString.Key.font: UIFont(name: "Avenir Heavy", size: 34) as Any,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
    }
    
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
    
    private func prepareTableView() {
        self.moviesList?.delegate = self
        self.moviesList?.dataSource = self
        
        self.moviesList?
            .register(CustomTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
        self.moviesList?.registerCell(cellClass: CollectionTableViewCell.self)
    }
    
    // MARK: -
    // MARK: Overrided
    
    override func prepareBindings(disposeBag: DisposeBag) {
        self.viewModel.movies
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.moviesList?.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: -
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.genres.value.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                       "sectionHeader") as? CustomTableViewHeader
        view?.title.text = self.viewModel.genres.value[section].name

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
        let id = self.viewModel.genres.value[indexPath.section].id
        cell.fill(with: self.viewModel.movies.value[id] ?? [])
        
        if indexPath.section == 0 {
            cell.onFirstSection = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200.0
    }
}
