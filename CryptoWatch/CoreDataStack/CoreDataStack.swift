//
//  CoreDataStack.swift
//  CryptoWatch
//
//  Created by Mark Kim on 3/21/21.
//

import Foundation
import CoreData

enum FetchMyCoinResult {
    case success([MyCoin])
    case failure(Error)
}

class CoreDataStack {
    
    //MARK: Properties
    private let modelName: String
    
    static let shared: CoreDataStack = CoreDataStack(modelName: "CryptoWatch")
    
    lazy var fetchedContext: NSFetchRequest<MyCoin> = {
        return MyCoin.fetchRequest()
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("CoreData store container error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    //MARK: Initialize
    init(modelName: String) {
        self.modelName = modelName
    }
}

//MARK: Methods
extension CoreDataStack {
    func saveContext() {
        guard mainContext.hasChanges else { return }
        do {
            try mainContext.save()
        } catch let nserror as NSError {
            fatalError("Error saving context in CoreData \(nserror), \(nserror.userInfo)")
        }
    }
    
    func fetchPersistentData(completion: @escaping (FetchMyCoinResult) -> Void) {
        do {
            let allMyCoins = try mainContext.fetch(fetchedContext)
            completion(.success(allMyCoins))
        } catch {
            completion(.failure(error))
        }
    }
}


