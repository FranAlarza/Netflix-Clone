//
//  DataPersistenceManager.swift
//  Netflix Clone
//
//  Created by Fran Alarza on 27/8/22.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    
    enum DataBaseError: Error {
        case failedToSave
        case failToFetch
        case failedToDeleteData
    }
    static let shared = DataPersistenceManager()
    
    func downloadTitleWith(model: Movie, completion: @escaping (Void?, Error?) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        item.original_title = model.original_title
        item.id = Int64(model.id)
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.title = model.title
        item.vote_average = model.vote_average
        item.name = model.name
        
        do {
            try context.save()
            completion((), nil)
        } catch {
            completion(nil, DataBaseError.failedToSave)
        }
    }
    
    func fetchingTitlesFromDatabase(completion: @escaping ([TitleItem]?, Error?) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            completion(titles, nil)
            
        } catch {
            completion(nil, DataBaseError.failToFetch)
        }
    }
    
    func deleteTitleWith(model: TitleItem, completion: @escaping (Void?, Error?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion((), nil)
        } catch {
            completion(nil, DataBaseError.failedToDeleteData)
        }
    }
}
