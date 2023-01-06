//
//  GenresListView.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 28.12.2022.
//  Copyright © 2022 IDAP. All rights reserved.
	

import UIKit

import RxSwift
import RxRelay

class GenresListView<Service: NetworkSessionProcessable>: BaseView<GenresListViewModel<Service>, GenresListViewModelOutputEvents>, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: -
    // MARK: Outlets
    
    @IBOutlet var moviesList: UITableView?
    @IBOutlet var tvShowsList: UITableView?
    @IBOutlet var segmentControl: CustomSegmentControl?
    @IBOutlet var moviesTableView: UITableView?
    @IBOutlet var tvshowsTableView: UITableView?
    
    // MARK: -
    // MARK: Variables
    
    private var genres: [Genre] = []
    private var trendMoviesImages: [UIImage?] = []
    private var imagesHandler: (([UIImage]) -> ())?
    
    // MARK: -
    // MARK: ViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareTitle()
        self.prepareContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.gradientBackground()
    }
    
    // MARK: -
    // MARK: Functions
    
    private func prepareTitle() {
        self.title = "Genres"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Avenir Heavy", size: 34) as Any, NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func prepareContent() {
        self.moviesList?.isHidden = false
        
        self.segmentControl?.onSelectTab = {
            self.moviesList?.isHidden = $0 == 1
            self.tvShowsList?.isHidden = $0 == 0
        }
        
        self.prepareTableViews()
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
    
    private func prepareTableViews() {
        self.moviesTableView?.delegate = self
        self.moviesTableView?.dataSource = self
        self.tvshowsTableView?.delegate = self
        self.tvshowsTableView?.dataSource = self
        
        self.moviesTableView?
            .register(CustomTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        self.tvshowsTableView?
            .register(CustomTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
        self.moviesTableView?.registerCell(cellClass: CollectionTableViewCell.self)
        self.tvshowsTableView?.registerCell(cellClass: CollectionTableViewCell.self)
    }
    
    // MARK: -
    // MARK: Overrided
    
    override func prepareBindings(disposeBag: DisposeBag) {
        self.viewModel.genres
            .bind { [weak self] in
                self?.genres = $0
                self?.moviesTableView?.reloadData()
                self?.tvshowsTableView?.reloadData()
            }
            .disposed(by: disposeBag)
        
        self.viewModel.posters
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                print("<!> posters.count = \(self?.viewModel.posters.value.count)")
                self?.trendMoviesImages = $0
                self?.moviesTableView?.reloadData()
                self?.tvshowsTableView?.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: -
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.genres.count + 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                       "sectionHeader") as? CustomTableViewHeader
        switch section {
        case 0:
            view?.title.text = "Trend Movies"
        default:
            view?.title.text = self.genres[section - 1].name
        }

           return view
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel?.textColor = .white
            view.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            view.backgroundColor = .green
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withCellClass: CollectionTableViewCell.self, for: indexPath)
        
        cell.fill(with: self.viewModel.trendMovies.value, and: self.trendMoviesImages)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        190.0
    }
}
