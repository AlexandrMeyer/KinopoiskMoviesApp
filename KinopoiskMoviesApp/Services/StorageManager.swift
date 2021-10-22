//
//  StorageManager.swift
//  KinopoiskMoviesApp
//
//  Created by Александр on 16.10.21.
//

import Foundation
import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "KinopoiskMoviesApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {}
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Востанавливаем данные из базы
    func fetchData(completion: (Result<[Movie], Error>) -> Void) {
        let fetchRequest = Movie.fetchRequest()
        
        do {
            let movies = try viewContext.fetch(fetchRequest)
            completion(.success(movies))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func save(_ newMovie: Film) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Movie", in: viewContext) else { return }
        guard let movie = NSManagedObject(entity: entityDescription, insertInto: viewContext) as? Movie else { return }
        movie.title = newMovie.title
        movie.poster = newMovie.poster
        guard let year = newMovie.year else { return }
        movie.year = Int64(year)
        saveContext()
    }
    
    func delete(_ movie: Movie) {
        viewContext.delete(movie)
        saveContext()
    }
}
