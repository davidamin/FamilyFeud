//
//  User.swift
//  FamilyFeud
//
//  Created by David Amin on 11/1/15.
//  Copyright © 2015 David Amin. All rights reserved.
//

import Foundation
import CoreData


class User: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    @NSManaged var name: String
    @NSManaged var highScore: NSNumber
    @NSManaged var gamesPlayed: NSNumber
    @NSManaged var perfectBoards: NSNumber
    @NSManaged var bestGame: NSNumber
    @NSManaged var bestFast: NSNumber
    @NSManaged var bestTotal: NSNumber
}
