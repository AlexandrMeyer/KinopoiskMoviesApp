//
//  MoviesListViewController.swift
//  KinopoiskMoviesApp
//
//  Created by Александр on 13.10.21.
//

import UIKit

class MoviesListViewController: UITableViewController {
    
    private var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviesCell", for: indexPath) as! CoreDataMovieCell
        let movie = movies[indexPath.row]
        cell.configure(with: movie)
        
        return cell
    }
    
    private func fetchData() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let movies):
                self.movies = movies
            case .failure(let error):
                print(error.localizedDescription)
            }
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let movie = movies[indexPath.row]
        
        if editingStyle == .delete {
            movies.remove(at: indexPath.row)
            StorageManager.shared.delete(movie)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
