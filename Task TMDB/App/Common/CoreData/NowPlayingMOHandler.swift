//
//  PopularMOHandler.swift
//  Task TMDB
//
//  Created by Haris Jamil on 11/12/2024.
//

import Foundation
import CoreData

class PopularMOHandler {
    static func clearPopularMO(moc: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PopularMO")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try moc.execute(batchDeleteRequest)
        } catch {
            print("Could not delete PopularMO entity records. \(error)")
        }
    }
    
    static func saveCurrentMovieList(_ movieInfoList: [MovieInfoModel], moc: NSManagedObjectContext) {
        PopularMOHandler.clearPopularMO(moc: moc)
        if let entity = NSEntityDescription.entity(forEntityName: "PopularMO", in: moc) {
            let PopularMO = NSManagedObject(entity: entity, insertInto: moc)
            let movieListData = try? JSONEncoder().encode(movieInfoList)
            PopularMO.setValue(movieListData, forKeyPath: "movieListData")
            PopularMO.setValue(Date(), forKey: "timeStamp")
            
            do {
                try moc.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    static func fetchSavedPopularMovieList(in moc: NSManagedObjectContext) -> [MovieInfoModel] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PopularMO")
        do {
            let popularMO = try moc.fetch(fetchRequest)
            if popularMO.count > 0,
               let loadedMovieListData = popularMO[0].value(forKey: "movieListData") as? Data {
                if let loadedMovieList = try? JSONDecoder().decode([MovieInfoModel].self, from: loadedMovieListData) {
                    return loadedMovieList
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
}
