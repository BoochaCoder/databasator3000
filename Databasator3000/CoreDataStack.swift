
import CoreData
import UIKit


class CoreDataStack {
    //
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        //   Container, který má pod sebou další vrstvy core dat.
        
        let container = NSPersistentContainer(name: "DataBaze")
        let seededData: String = "DataBaze"
        var persistentStoreDescriptions: NSPersistentStoreDescription
        
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let storeUrl = URL(fileURLWithPath: documentDirectoryPath!).appendingPathComponent("DataBaze")

        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeUrl)]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                
                fatalError("Unresolved error \(error),")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    } 
}
