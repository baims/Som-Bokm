//
//  SavedStoryCollectionViewCell.swift
//  StoryTelling
//
//  Created by Bader Alrshaid on 7/31/15.
//  Copyright (c) 2015 Bader Alrshaid. All rights reserved.
//

import UIKit

class SavedStoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    
    
    var storyTelling : StoryTelling!
}
