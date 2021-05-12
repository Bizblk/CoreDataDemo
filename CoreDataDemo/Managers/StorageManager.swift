//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Виталий Оранский on 11.05.2021.
//
import CoreData
import UIKit

class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var context = persistentContainer.viewContext
    
    private init() {}
    
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData(completion: ([Task]) -> Void) {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            let taskList = try context.fetch(fetchRequest)
            completion(taskList)
        } catch let error {
            print(error)
        }
    }
    
    
    func createTask() -> Task? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return nil }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return nil }
        return task
    }
    
    
    func editTask(task: Task, newValue: String) {
        
        do {
            task.title = newValue
            try context.save()
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }    
    
    func deleteTask(task: Task) {
        context.delete(task)
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    

    
}
