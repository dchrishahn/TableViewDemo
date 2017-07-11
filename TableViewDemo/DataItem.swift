//
//  DataItem.swift
//  TableViewDemo
//
//  Created by Chris Hahn on 7/6/17.
//  Copyright © 2017 Sturnella. All rights reserved.
//

import UIKit

class DataItem {

   var title: String
// Subtitle changes ... following line removed
//  var subtitle: String
    var image: UIImage?

// Subtitle changes ... following line changed
//  init(title: String, subtitle: String, imageName: String?) {
    init(title: String, imageName: String?) {
        self.title = title
// Subtitle changes ... following line removed
//      self.subtitle = subtitle
        if let imageName = imageName {
            if let img = UIImage(named: imageName) {
                image = img
            }
        }
    }
}
