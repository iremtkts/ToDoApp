
import Foundation
import CoreData
import UIKit


class DataManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [ToDoList]()

    
    func getAllItem() -> [ToDoList] {
        do {
            models = try context.fetch(ToDoList.fetchRequest())
           
        } catch {
            print(error.localizedDescription)
            
        }
        return models
    }
    
    func createItem(name: String) {
        let newItem = ToDoList(context: context)
        newItem.name = name

        do {
            try context.save()
            models = getAllItem()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func deleteItem(item: ToDoList){
        
        context.delete(item)
        
        do {
            try context.save()
            models = getAllItem()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func updateItem(item: ToDoList, newName: String) {
        
        item.name = newName
        
        do {
            try context.save()
            models = getAllItem()
        } catch {
            print(error.localizedDescription)
        }
        
    }

}


