//
//  CoreDataMovieCell.swift
//  KinopoiskMoviesApp
//
//  Created by Александр on 17.10.21.
//

import UIKit

class CoreDataMovieCell: UITableViewCell {
    
    @IBOutlet var posterImageView: MovieImageView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    
    func configure(with movie: Movie?) {
        titleLabel.text = movie?.title
        yearLabel.text = String(movie?.year ?? 0)
        guard let stringURL = movie?.poster else { return }
        posterImageView.fetchImage(from: stringURL)
    }
}
