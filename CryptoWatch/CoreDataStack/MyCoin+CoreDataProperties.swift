//
//  MyCoin+CoreDataProperties.swift
//  
//
//  Created by Mark Kim on 3/22/21.
//
//

import Foundation
import CoreData


extension MyCoin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyCoin> {
        return NSFetchRequest<MyCoin>(entityName: "MyCoin")
    }

    @NSManaged public var assetId: String?
    @NSManaged public var high: Double
    @NSManaged public var icon: String?
    @NSManaged public var low: Double
    @NSManaged public var name: String?

}
