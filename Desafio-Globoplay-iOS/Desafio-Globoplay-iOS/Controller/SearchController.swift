//
//  SearchController.swift
//  Desafio-Globoplay-iOS
//
//  Created by Gáudio Ney on 25/02/22.
//

import UIKit

class SearchController: UIViewController {
    
    // MARK: - Properties
    
    private var movies: [Movie] = [Movie]()
    
    private let searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchSearch()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTableView.frame = view.bounds
    }
    
    // MARK: - API
    
    private func fetchSearch() {
            MovieClient.shared.getUpcomingMovies { [weak self] result in
                switch result {
                case .success(let movies):
                    self?.movies = movies ?? []
                    DispatchQueue.main.async {
                        self?.searchTableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    
    // MARK: - Helper Methods
    
    func configureUI() {
        view.backgroundColor = .black
        view.addSubview(searchTableView)
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    // MARK: - Selectors
    
}

extension SearchController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier, for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = movies[indexPath.row]
        cell.configure(with: SearchViewModel(movieName: (movie.originalTitle ?? movie.originalName) ?? "Unknown title name", posterURL: movie.posterPath ?? ""))
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}