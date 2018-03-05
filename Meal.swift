//
//  Meal.swift
//  Track Macros
//
//  Created by Shahir Abdul-Satar on 2/10/18.
//  Copyright © 2018 Ahmad Shahir Abdul-Satar. All rights reserved.
//

import Foundation
import UIKit

class Meal: NSObject, NSCoding {
    
    
    var calories: Int?
    var carbohydrates: Int?
    var protein: Int?
    var fats: Int?
    var month: Int?
    var day: Int?
    var year: Int?
    
    
    init(calories: Int, carbohydrates: Int, protein: Int, fats: Int, month: Int, day: Int, year: Int) {
        self.calories = calories
        self.carbohydrates = carbohydrates
        self.protein = protein
        self.fats = fats
        self.month = month
        self.day = day
        self.year = year
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let calories = aDecoder.decodeObject(forKey: "calories") as! Int
        let carbohydrates = aDecoder.decodeObject(forKey: "carbohydrates") as! Int
        let protein = aDecoder.decodeObject(forKey: "protein") as! Int
        let fats = aDecoder.decodeObject(forKey: "fats") as! Int
        let month = aDecoder.decodeObject(forKey: "month") as! Int
        let day = aDecoder.decodeObject(forKey: "day") as! Int
        let year = aDecoder.decodeObject(forKey: "year") as! Int

       self.init(calories: calories, carbohydrates: carbohydrates, protein: protein, fats: fats, month: month, day: day, year: year)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(calories, forKey: "calories")
        aCoder.encode(carbohydrates, forKey: "carbohydrates")
        aCoder.encode(protein, forKey: "protein")
        aCoder.encode(fats, forKey: "fats")
        aCoder.encode(month, forKey: "month")
        aCoder.encode(day, forKey: "day")
        aCoder.encode(year, forKey: "year")

    }
    
    
}
