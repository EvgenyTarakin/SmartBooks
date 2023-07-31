//
//  DataManager.swift
//  
//
//  Created by Евгений Таракин on 06.02.2023.
//

import Foundation
import CoreData

final class DataManager: Hashable {
    
//    MARK: - property
    private let context = CoreDataManager.persistentContainer.viewContext
    
    var readers: [Reader] {
        let fetchRequest: NSFetchRequest<Reader> = Reader.fetchRequest()
        do {
            return try context.fetch(fetchRequest).reversed()
        } catch let error as NSError {
            print(error.localizedDescription)
            return []
        }
    }
    
    var books: [Book] {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        do {
            return try context.fetch(fetchRequest).reversed()
        } catch let error as NSError {
            print(error.localizedDescription)
            return []
        }
    }
    
//    MARK: - func
    // Readers
    func saveReader(name: String, date: String, info: Int16) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Reader", in: context) else { return }
        
        let object = Reader(entity: entity, insertInto: context)
        object.name = name
        object.date = date
        object.info = info
        saveContext()
    }
    
    func deleteReader(_ reader: Reader) {
        let fetchRequest: NSFetchRequest<Reader> = Reader.fetchRequest()
        if let objects = try? context.fetch(fetchRequest) {
            for object in objects {
                if object == reader {
                    context.delete(object)
                }
            }
        }
        saveContext()
    }
    
    // Books
    func saveBook(name: String, author: String, count: Int64) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Book", in: context) else { return }
        
        let object = Book(entity: entity, insertInto: context)
        object.name = name
        object.author = author
        object.count = count
        saveContext()
    }
    
    // MARK: - private func
    private func saveContext() {
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - other
    let uuid = UUID()
    static func ==(lhs: DataManager, rhs: DataManager) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
}
