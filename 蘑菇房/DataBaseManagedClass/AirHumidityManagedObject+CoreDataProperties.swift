//
//  AirHumidityManagedObject+CoreDataProperties.swift
//  蘑菇房
//
//  Created by 芒果君 on 2016/11/12.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import Foundation
import CoreData


extension AirHumidityManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AirHumidityManagedObject> {
        return NSFetchRequest<AirHumidityManagedObject>(entityName: "AirHumidity");
    }

    @NSManaged public var base_ID: Int64
    @NSManaged public var crops_ID: Int64
    @NSManaged public var data_ID: Int64
    @NSManaged public var time: Int64
    @NSManaged public var user_ID: Int64
    @NSManaged public var value: Double

}
