//
//  BaseManagedObject+CoreDataProperties.swift
//  蘑菇房
//
//  Created by 芒果君 on 2016/12/5.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension BaseManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BaseManagedObject> {
        return NSFetchRequest<BaseManagedObject>(entityName: "Base");
    }

    @NSManaged public var base_ID: Int64
    @NSManaged public var user_ID: Int64

}
