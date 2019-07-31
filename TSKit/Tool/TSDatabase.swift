//
//  TSData.swift
//  TSKit
//
//  Created by mc on 2018/9/3.
//  Copyright © 2018年 张玉飞. All rights reserved.
//

import CoreData

class TSDatabase {
    /// 存储调度器
    var persistentContainer: NSPersistentContainer
    /// 管理对象上下文
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(name: String) {
        
        persistentContainer = NSPersistentContainer(name: name)
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("CoreData加载失败 \(error), \(error.userInfo)")
            }
        })
    }
    
    func insert<T>() -> T {
        let entity = "\(type(of: T.self))".components(separatedBy: ".").first!
        return NSEntityDescription.insertNewObject(forEntityName: entity, into: context) as! T
    }
    
    func searchOne<T>(condition: String) -> T? {
        let entity = "\(type(of: T.self))".components(separatedBy: ".").first!
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        request.predicate = NSPredicate(format: condition)
        if let results = try? context.fetch(request) {
            return results.first as? T
        } else {
            return nil
        }
    }
    
    func searchAll<T>(condition: String? = nil) -> [T]? {
        let entity = "\(type(of: T.self))".components(separatedBy: ".").first!
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        if let condition = condition {
            request.predicate = NSPredicate(format: condition)
        }
        if let results = try? context.fetch(request) {
            return results as? [T]
        } else {
            return nil
        }
    }
    
    func delete<T: NSManagedObject>(object: T) {
        context.delete(object)
        save()
    }
    
    func deleteAll<T: NSManagedObject>(condition: String, class: T.Type) {
        let results: [T]? = searchAll(condition: condition)
        if let results = results {
            for obj in results {
                delete(object: obj)
            }
        }
    }
    
    func save() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
