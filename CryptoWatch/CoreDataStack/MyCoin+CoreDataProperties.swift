//
//  MyCoin+CoreDataProperties.swift
//  
//
//  Created by Mark Kim on 5/3/21.
//
//

import Foundation
import CoreData


extension MyCoin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyCoin> {
        return NSFetchRequest<MyCoin>(entityName: "MyCoin")
    }

    @NSManaged public var assetId: String?
    @NSManaged public var name: String?
    @NSManaged public var targetPrice: Double
    @NSManaged public var icon: String?

}
