//
//  ViewController.swift
//  KinopoiskMoviesApp
//
//  Created by Александр on 12.10.21.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var detailImageView: MovieImageView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var titleEnLabel: UILabel!
    @IBOutlet var directorLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var actorLabel: UILabel!
    
    var film: Film!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        titleLabel.text = ""
        titleEnLabel.text = ""
        directorLabel.text = ""
        yearLabel.text = ""
        descriptionLabel.text = ""
        actorLabel.text = ""
        
        updateUI()
    }
    
    @IBAction func addToFavoriteButtonTapped(_ sender: UIBarButtonItem) {
        StorageManager.shared.save(self.film)
        showAlert(with: self.film.title)
    }
    
    private func updateUI() {
        titleLabel.text = film.title
        titleEnLabel.text = film.titleEn
        directorLabel.text = film.directors.map{ $0.joined(separator: "") }
        guard let year = film.year else { return }
        yearLabel.text = String(year)
        descriptionLabel.text = film.description
        actorLabel.text = film.actors.map{ $0.joined(separator: "\n") }
        
        detailImageView.fetchImage(from: film.poster ?? "")
    }
    
    private func showAlert(with title: String) {
        let alertController = UIAlertController(title: title, message: "Add to Favorite", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

