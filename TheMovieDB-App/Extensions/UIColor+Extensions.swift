//
//  UIColor+Extensions.swift
//  TheMovieDB-App
//
//  Created by Aleksandr Ermakov on 29.01.2023.
//  Copyright © 2023 IDAP. All rights reserved.
	

import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}
