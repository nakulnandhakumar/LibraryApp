//
//  Books+CoreDataProperties.swift
//  TableProject
//
//  Created by Nakul Nandhakumar on 4/30/20.
//  Copyright © 2020 Nakul Nandhakumar. All rights reserved.
//
//

import Foundation
import CoreData


extension Books {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Books> {
        return NSFetchRequest<Books>(entityName: "Books")
    }

    @NSManaged public var bookName: String?
    @NSManaged public var image: Data?
    @NSManaged public var author: String?

}
