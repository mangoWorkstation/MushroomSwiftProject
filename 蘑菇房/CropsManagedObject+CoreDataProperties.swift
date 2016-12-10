//
//  CropsManagedObject+CoreDataProperties.swift
//  蘑菇房
//
//  Created by 芒果君 on 2016/12/5.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import Foundation
import CoreData


extension CropsManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CropsManagedObject> {
        return NSFetchRequest<CropsManagedObject>(entityName: "Crops");
    }

    @NSManaged public var crops_ID: Int64
    @NSManaged public var crops_name: String?

}
