//
//  MyCoin+CoreDataProperties.swift
//  
//
//  Created by Mark Kim on 6/15/21.
//
//

import Foundation
import CoreData


extension MyCoin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyCoin> {
        return NSFetchRequest<MyCoin>(entityName: "MyCoin")
    }

    @NSManaged public var assetId: String?
    @NSManaged public var currentPrice: Double
    @NSManaged public var icon: String?
    @NSManaged public var name: String?
    @NSManaged public var targetPrice: Double

}
