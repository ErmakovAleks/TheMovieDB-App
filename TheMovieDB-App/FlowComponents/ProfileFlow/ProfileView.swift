//
//  ProfileView.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 26.04.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

import RxSwift
import RxRelay

class ProfileView: BaseView<ProfileViewModel, ProfileViewModelOutputEvents> {
    
    // MARK: -
    // MARK: Outlets
    
    @IBOutlet var avatarView: UIView?
    @IBOutlet var avatarImageView: UIImageView?
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var nickNameLabel: UILabel?
    
    // MARK: -
    // MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepare()
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func prepare() {
        self.avatarView?.backgroundColor = Colors.gradientBottom
        self.avatarView?.layer.cornerRadius = (self.avatarView?.frame.height ?? 0.0) / 2.0
        self.avatarImageView?.layer.cornerRadius = (self.avatarImageView?.frame.height ?? 0.0) / 2.0
        self.nameLabel?.text = UserDefaults.standard.string(forKey: "Name")
        self.nickNameLabel?.text = UserDefaults.standard.string(forKey: "UserName")
        self.viewModel.fetchAvatar(endPath: UserDefaults.standard.string(forKey: "Avatar") ?? "") { [weak self] image in
            self?.avatarImageView?.image = image
        }
    }
}
