//
//  Stack.swift
//  DevelopU
//
//  Created by Sterling Mortensen on 4/4/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//

import Foundation
import CoreData

enum Stack {
    
    static let container: NSPersistentContainer =  {
        let container = NSPersistentContainer(name: "DevelopU")
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Error loading persistent stores: \(error.userInfo)")
            }
        })
        return container
    }()
    
    static var context: NSManagedObjectContext {return container.viewContext}
}

