//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Виталий Оранский on 11.05.2021.
//
import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext
    
    
    private init() {
        context = persistentContainer.viewContext
    }
    
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
    
    func save(_ taskName: String, completion: (Task) -> Void) {
        let task = Task(context: context)
        task.title = taskName
        
        completion(task)
        saveContext()
    }
    
    func editTask(task: Task, newValue: String) {
        task.title = newValue
        saveContext()
    }    
    
    func deleteTask(task: Task) {
        context.delete(task)
        saveContext()
    }
    
    
    
}
