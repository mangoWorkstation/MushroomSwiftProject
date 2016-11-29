//
//  UserPropertiesManagedObject+CoreDataProperties.swift
//  蘑菇房
//
//  Created by 芒果君 on 2016/11/22.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import Foundation
import CoreData


extension UserPropertiesManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserPropertiesManagedObject> {
        return NSFetchRequest<UserPropertiesManagedObject>(entityName: "UserProperties");
    }

    @NSManaged public var id: Int64
    @NSManaged public var sex: Int64
    @NSManaged public var province: String?
    @NSManaged public var password: String?
    @NSManaged public var city: String?
    @NSManaged public var root: Int64
    @NSManaged public var allowPushingNotification: Bool
    @NSManaged public var allowPushingNewMessageToMobile: Bool

}
