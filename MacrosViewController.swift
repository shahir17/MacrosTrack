//
//  MacrosViewController.swift
//  Track Macros
//
//  Created by Shahir Abdul-Satar on 2/11/18.
//  Copyright © 2018 Ahmad Shahir Abdul-Satar. All rights reserved.
//

import UIKit

class MacrosViewController: UIViewController {
    
    var user = User()
    var totalCalories = 0
    var totalCarbs = 0
    var totalProtein = 0
    var totalFats = 0
    var container = UIView()
    var navBarHeight = CGFloat()
    
    var macrosView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Macros"
        self.view.backgroundColor = UIColor.white
        navBarHeight = (self.navigationController?.navigationBar.frame.height)!
        let width = self.view.bounds.width
        let height = self.view.bounds.height
        
        
//        containerView.frame = CGRect(x: 0, y: navBarHeight+currentDayLabel.bounds.height, width: width, height: height)
        view.addSubview(containerView)
        
        view.addSubview(currentDayLabel)
        containerView.addSubview(caloriesLabel)
        containerView.addSubview(carbsLabel)
        containerView.addSubview(proteinLabel)
        containerView.addSubview(fatsLabel)
        containerView.addSubview(calNumber)
        containerView.addSubview(carbsNumber)
        containerView.addSubview(proteinNumber)
        containerView.addSubview(fatsNumber)
        let today = Date()
        let weekday = Calendar.current.component(.weekday, from: today)
        let month = Calendar.current.component(.month, from: today)
        let day = Calendar.current.component(.day, from: today)
        let year = Calendar.current.component(.year, from: today)
        print(weekday)
        print(month)
        print(day)
        print(year)
        print(Calendar.current.weekdaySymbols[weekday-1])
        print(Calendar.current.shortMonthSymbols[month-1])
        let currentDate = Calendar.current.weekdaySymbols[weekday-1] + ", " + Calendar.current.shortMonthSymbols[month-1] + " " + String(day) + ", " + String(year)
        currentDayLabel.text = currentDate

        self.view.addSubview(caloriesLabel)
        self.view.addSubview(carbsLabel)
        self.view.addSubview(proteinLabel)
        self.view.addSubview(fatsLabel)
        self.view.addSubview(calNumber)
        self.view.addSubview(carbsNumber)
        self.view.addSubview(proteinNumber)
        self.view.addSubview(fatsNumber)

        print("Received Data Successfully:")
        let defaults = UserDefaults.standard
        totalCalories = defaults.object(forKey: "totalCalories") as! Int
        totalCarbs = defaults.object(forKey: "totalCarbs") as! Int
        totalProtein = defaults.object(forKey: "totalProtein") as! Int
        totalFats = defaults.object(forKey: "totalFats") as! Int

        
        
        
        
        print(self.totalCalories)
        print(self.totalCarbs)
        print(self.totalProtein)
        print(self.totalFats)
        
        print("user goals: ")
        if let getUser : User = user {
            print(getUser.calories!)
            calNumber.text = String(getUser.calories!-totalCalories)
            carbsNumber.text = String(getUser.carbohydrates!-totalCarbs)
            proteinNumber.text = String(getUser.protein!-totalProtein)
            fatsNumber.text = String(getUser.fats!-totalFats)

        }
        else {
            print("error")
        }
        
    setUpConstraints()
        
        
    }
    
    
    var containerView: UIView! = {
        
        
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
        
    }()
    
    
    
    
    
        var caloriesLabel: UILabel! = {
        
        let label = UILabel()
        label.text = "Calories"
            label.font = label.font.withSize(26)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
    
        return label
        
        
    }()
    
    var carbsLabel: UILabel! = {
        
        let label = UILabel()
        label.text = "Carbs"
        label.font = label.font.withSize(26)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
        
        
    }()
    
    var proteinLabel: UILabel! = {
        
        let label = UILabel()
        label.text = "Protein"
        label.font = label.font.withSize(26)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
        
        
    }()
    
    var fatsLabel: UILabel! = {
        
        let label = UILabel()
        label.text = "Fats"
        label.font = label.font.withSize(26)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
        
        
    }()
    
    
    lazy var currentDayLabel: UILabel! = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.layer.borderWidth = 0.5
        label.backgroundColor = UIColor(white: 1, alpha: 1)
        let color = UIColor.black
        label.layer.borderColor = color.cgColor
        label.layer.cornerRadius = 5
        return label
        
        
    }()
    
    
    var calNumber: UILabel! = {
        
        let label = UILabel()
        
        label.font = label.font.withSize(20)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
        
        
    }()

    var carbsNumber: UILabel! = {
        
        let label = UILabel()
        
        label.font = label.font.withSize(20)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
        
        
    }()

    var proteinNumber: UILabel! = {
        
        let label = UILabel()
        label.font = label.font.withSize(20)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
        
        
    }()
    var fatsNumber: UILabel! = {
        
        let label = UILabel()
        label.font = label.font.withSize(20)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
        
        
    }()

    
    
    
    
    
    
    func setUpConstraints(){
        
        
        
        currentDayLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5).isActive = true
        currentDayLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
        currentDayLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 75).isActive = true
        currentDayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        
        containerView.topAnchor.constraint(equalTo: currentDayLabel.bottomAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        
        caloriesLabel.topAnchor.constraint(equalTo: currentDayLabel.bottomAnchor, constant: navBarHeight).isActive = true
        caloriesLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        //caloriesLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -7).isActive = true
        caloriesLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        calNumber.topAnchor.constraint(equalTo: caloriesLabel.bottomAnchor, constant: 35).isActive = true
        calNumber.centerXAnchor.constraint(equalTo: caloriesLabel.centerXAnchor).isActive = true
        calNumber.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        carbsLabel.topAnchor.constraint(equalTo: currentDayLabel.bottomAnchor, constant: navBarHeight).isActive = true
        carbsLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
//        carbsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        carbsLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        carbsNumber.topAnchor.constraint(equalTo: carbsLabel.bottomAnchor, constant: 35).isActive = true
        carbsNumber.centerXAnchor.constraint(equalTo: carbsLabel.centerXAnchor).isActive = true
        carbsNumber.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        proteinLabel.topAnchor.constraint(equalTo: caloriesLabel.bottomAnchor, constant: navBarHeight+navBarHeight+navBarHeight+navBarHeight).isActive = true

        proteinLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
//        proteinLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -15).isActive = true

        proteinLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        proteinNumber.topAnchor.constraint(equalTo: proteinLabel.bottomAnchor, constant: 35).isActive = true
        proteinNumber.centerXAnchor.constraint(equalTo: proteinLabel.centerXAnchor).isActive = true
        proteinNumber.heightAnchor.constraint(equalToConstant: 35).isActive = true

        fatsLabel.topAnchor.constraint(equalTo: carbsLabel.bottomAnchor, constant: navBarHeight+navBarHeight+navBarHeight+navBarHeight).isActive = true

        fatsLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
//        fatsLabel.leftAnchor.constraint(equalTo: container.rightAnchor, constant: 15).isActive = true

        fatsLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        fatsNumber.topAnchor.constraint(equalTo: fatsLabel.bottomAnchor, constant: 35).isActive = true
        fatsNumber.centerXAnchor.constraint(equalTo: fatsLabel.centerXAnchor).isActive = true
        fatsNumber.heightAnchor.constraint(equalToConstant: 35).isActive = true

        
    }
    
    
    
    

    


}
