//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Sultan on 14/12/23.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
