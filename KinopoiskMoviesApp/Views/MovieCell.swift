//
//  MovieCell.swift
//  KinopoiskMoviesApp
//
//  Created by Александр on 12.10.21.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet var posterImageView: MovieImageView! 
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    
    func configure(with film: Film?) {
        titleLabel.text = film?.title
        yearLabel.text = String(film?.year ?? 0)
        guard let stringURL = film?.poster else { return }
        posterImageView.fetchImage(from: stringURL)
    }
}
