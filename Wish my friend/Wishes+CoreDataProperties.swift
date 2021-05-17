//
//  Wishes+CoreDataProperties.swift
//  
//
//  Created by Sarath Chandra Damineni on 05/03/2021.
//
//

import Foundation
import CoreData


extension Wishes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wishes> {
        return NSFetchRequest<Wishes>(entityName: "Wishes")
    }

    @NSManaged public var wish1: String?
    @NSManaged public var relation: String?

}
