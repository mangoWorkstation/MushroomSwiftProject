//
//  UserPropertiesManagedObject+CoreDataProperties.swift
//  蘑菇房
//
//  Created by 芒果君 on 2016/12/5.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import Foundation
import CoreData


extension UserPropertiesManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserPropertiesManagedObject> {
        return NSFetchRequest<UserPropertiesManagedObject>(entityName: "UserProperties");
    }

    @NSManaged public var allowPushingNewMessageToMobile: Bool
    @NSManaged public var allowPushingNotification: Bool
    @NSManaged public var city: String?
    @NSManaged public var facePath: String?
    @NSManaged public var id: Int64
    @NSManaged public var nickName: String?
    @NSManaged public var password: String?
    @NSManaged public var province: String?
    @NSManaged public var root: Int64
    @NSManaged public var sex: Int64

}
