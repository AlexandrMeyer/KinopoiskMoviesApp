//
//  SearchListViewController.swift
//  KinopoiskMoviesApp
//
//  Created by Александр on 12.10.21.
//

import UIKit

class SearchListViewController: UITableViewController {
    
    private var movies: Movies?
    private var filteredFilm: [Film] = []
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Movies list"
        tableView.rowHeight = 100
        fetchMoviesInfo()
        setupSearchController()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredFilm.count : movies?.movies.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! MovieCell
        let movie = isFiltering ? filteredFilm[indexPath.row] : movies?.movies[indexPath.row]
        cell.configure(with: movie)
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? DetailViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let film = isFiltering ? filteredFilm[indexPath.row] : movies?.movies[indexPath.row]
        detailVC.film = film
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsSearchResultsController = true
        searchController.searchBar.placeholder = "Search"
        definesPresentationContext = true
    }
    
    private func fetchMoviesInfo() {
        NetworkManager.shared.fetchMoviesInfo { [unowned self] result in
            switch result {
            case .success(let movie):
                DispatchQueue.main.async {
                    movies = movie
                    tableView.reloadData()
                }
            case .failure(let error):
                print (error)
            }
        }
    }
}

extension SearchListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredFilm = movies?.movies.filter { film in
            film.title.lowercased().contains(searchText.lowercased())
        } ?? []
        
        tableView.reloadData()
    }
}
