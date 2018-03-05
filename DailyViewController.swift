//
//  DailyViewController.swift
//  Track Macros
//
//  Created by Shahir Abdul-Satar on 2/10/18.
//  Copyright © 2018 Ahmad Shahir Abdul-Satar. All rights reserved.
//

import UIKit

class DailyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView : UITableView = UITableView()
    var sections = 0
    var sectionHeader = "Meal "
    var labelsForRows = ["Calories", "Carbohydrates", "Protein", "Fat"]
    var user = User()
    var meals = [Meal]()
    var totalCalories = 0
    var totalCarbs = 0
    var totalProtein = 0
    var totalFats = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "Daily"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Set Goal", style: .plain, target: self, action: #selector(createGoalsDialogBox))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Meal", style: .plain, target: self, action: #selector(createAddMealsDialogBox))
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 81/255, blue: 148/255, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        let navBarHeight = (self.navigationController?.navigationBar.frame.height)!
        view.addSubview(seeMacrosButton)
        //tableView.frame = CGRect(x: 0, y: navBarHeight+currentDayLabel.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        view.addSubview(tableView)
        view.addSubview(currentDayLabel)
        //add tableview
        view.bringSubview(toFront: seeMacrosButton)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        setUpConstraints()
        
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        tableView.frame = CGRect(x: 0, y:  60, width: displayWidth, height: displayHeight-150)
        
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
        
        let defaults = UserDefaults.standard
        if let decoded  = defaults.object(forKey: "meals") as? Data {
            let decodedMeals: [Meal] = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Meal]
            for object in decodedMeals {
                self.totalCalories += object.calories!
                self.totalCarbs += object.carbohydrates!
                self.totalProtein += object.protein!
                self.totalFats += object.fats!
                
                
                
            }

                defaults.set(self.totalCalories, forKey: "totalCalories")
                defaults.set(self.totalCarbs, forKey: "totalCarbs")
                defaults.set(self.totalProtein, forKey: "totalProtein")
                defaults.set(self.totalFats, forKey: "totalFats")

                self.meals = decodedMeals
        
                tableView.reloadData()
             
        }
        
        else {
            defaults.set(0, forKey: "totalCalories")
            defaults.set(0, forKey: "totalCarbs")
            defaults.set(0, forKey: "totalProtein")
            defaults.set(0, forKey: "totalFats")
            
        }
        resetGoals()
        resetMeals()
        
    
    }
    
    
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
    
    lazy var seeMacrosButton: UIButton! = {
        
        let button = UIButton()
        button.setTitle("See Macros", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 0/255, green: 81/255, blue: 148/255, alpha: 1.0)
        button.addTarget(self, action: #selector(onSeeMacrosButtonClick), for: .touchUpInside)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
        
    }()
    
    func createGoalsDialogBox(){

        let createGoalsAlertController = UIAlertController(title: "Set Macros Goals", message: "Enter calories, carbs, protein, and fats goals for the day", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Set", style: .default) { (_) in
            
            if (createGoalsAlertController.textFields?[0].text?.isEmpty)! || (createGoalsAlertController.textFields?[1].text?.isEmpty)! || (createGoalsAlertController.textFields?[2].text?.isEmpty)! || (createGoalsAlertController.textFields?[3].text?.isEmpty)! {
                let emptyTextFieldAlert = UIAlertController(title: "Empty Entry", message: "Make sure you don't leave any fields empty", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .cancel) { (_) in }
                emptyTextFieldAlert.addAction(okAction)
                self.present(emptyTextFieldAlert, animated: true, completion: nil)
                
            }
            else {
                let date = Date()
                let defaults = UserDefaults.standard

                let month = Calendar.current.component(.month, from: date)
                let day = Calendar.current.component(.day, from: date)
                let year = Calendar.current.component(.year, from: date)
                self.user.month = month
                self.user.day = day
                self.user.year = year
                //getting the input values from user
                
                if let cal = Int((createGoalsAlertController.textFields?[0].text)!),
                    let carb = Int((createGoalsAlertController.textFields?[1].text)!),
                    let prote = Int((createGoalsAlertController.textFields?[2].text)!),
                    let fat = Int((createGoalsAlertController.textFields?[3].text)!) {
                    self.user.calories = cal
                    self.user.carbohydrates = carb
                    self.user.protein = prote
                    self.user.fats = fat
                    defaults.set(cal, forKey: "userCal")
                    defaults.set(carb, forKey: "userCarb")
                    defaults.set(prote, forKey: "userProte")
                    defaults.set(fat, forKey: "userFat")
                    defaults.set(month, forKey: "userMonth")
                    defaults.set(day, forKey: "userDay")
                    defaults.set(year, forKey: "userYear")
                    defaults.synchronize()
                }
                print(self.user.calories!)
                print(self.user.carbohydrates!)
                print(self.user.protein!)
                print(self.user.fats!)
                print(self.user.month!)
                print(self.user.day!)
                print(self.user.year!)
                
            }
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        createGoalsAlertController.addTextField { (textField) in
            textField.placeholder = "Enter Calories"
            textField.keyboardType = .numberPad
        }
        createGoalsAlertController.addTextField { (textField) in
            textField.placeholder = "Enter Carbs"
            textField.keyboardType = .numberPad
            
        }
        createGoalsAlertController.addTextField { (textField) in
            textField.placeholder = "Enter Protein"
            textField.keyboardType = .numberPad
            
        }
        createGoalsAlertController.addTextField { (textField) in
            textField.placeholder = "Enter Fats"
            textField.keyboardType = .numberPad
            
        }
        
        //adding the action to dialogbox
        createGoalsAlertController.addAction(confirmAction)
        createGoalsAlertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(createGoalsAlertController, animated: true, completion: nil)
        
    
    }
    
    
    func onSeeMacrosButtonClick(){
        let defaults = UserDefaults.standard
        let goalCarb: Int = defaults.integer(forKey: "userCarb")
        let goalProte: Int = defaults.integer(forKey: "userProte")
         let goalFat: Int = defaults.integer(forKey: "userFat")
        let goalCal: Int = defaults.integer(forKey: "userCal")
        
        //if let getUser: User = self.user  {
            
        if goalCal != 0 {
                    let macrosVC = MacrosViewController()
            let userDefaults = UserDefaults.standard
            userDefaults.set(self.totalCalories, forKey: "totalCalories")
            userDefaults.set(self.totalCarbs, forKey: "totalCarbs")
            userDefaults.set(self.totalProtein, forKey: "totalProtein")
            userDefaults.set(self.totalFats, forKey: "totalFats")
            userDefaults.synchronize()
                    macrosVC.user.calories = goalCal
                    macrosVC.user.carbohydrates = goalCarb
                    macrosVC.user.protein = goalProte
                    macrosVC.user.fats = goalFat

                self.navigationController?.pushViewController(macrosVC, animated: true)
            }
            else if goalCal == 0 {
                let alert = UIAlertController(title: "Goals Empty", message: "First you need to set you goals for the day", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Got it", style: .cancel) { (_) in }
                alert.addAction(okAction)
                defaults.set(0, forKey: "totalCalories")
                defaults.set(0, forKey: "totalCarbs")
                defaults.set(0, forKey: "totalProtein")
                defaults.set(0, forKey: "totalFats")
            
                self.present(alert, animated: true, completion: nil)

            }
        else if self.meals.isEmpty == true{
            let alert = UIAlertController(title: "Meals Empty", message: "Make sure you enter at least one meal", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Got it", style: .cancel) { (_) in }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)

            
        }
        }
   
    

    
    func createAddMealsDialogBox(){
        
        let alertController = UIAlertController(title: "Create Meal", message: "Enter calories, carbs, protein, and fats", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Create", style: .default) { (_) in
            
            if (alertController.textFields?[0].text?.isEmpty)! || (alertController.textFields?[1].text?.isEmpty)! || (alertController.textFields?[2].text?.isEmpty)! || (alertController.textFields?[3].text?.isEmpty)! {
                let emptyTextFieldAlert = UIAlertController(title: "Empty Entry", message: "Make sure you don't leave any fields empty", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .cancel) { (_) in }
                emptyTextFieldAlert.addAction(okAction)
                self.present(emptyTextFieldAlert, animated: true, completion: nil)
                
            }
            else {
            let date = Date()

            let month = Calendar.current.component(.month, from: date)
            let day = Calendar.current.component(.day, from: date)
            let year = Calendar.current.component(.year, from: date)
            //getting the input values from user
            
            if let cal = Int((alertController.textFields?[0].text)!),
                let carb = Int((alertController.textFields?[1].text)!),
                let prote = Int((alertController.textFields?[2].text)!),
                let fat = Int((alertController.textFields?[3].text)!) {
                let meal = Meal(calories: cal, carbohydrates: carb, protein: prote, fats: fat, month: month, day: day, year: year)
                self.totalCalories += cal
                self.totalCarbs += carb
                self.totalProtein += prote
                self.totalFats += fat
                self.meals.append(meal)
                
                let userDefaults = UserDefaults.standard
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.meals)
                userDefaults.set(encodedData, forKey: "meals")
                self.sections += 1
                userDefaults.set(self.sections, forKey: "sections")
                userDefaults.set(self.totalCalories, forKey: "totalCalories")
                userDefaults.set(self.totalCarbs, forKey: "totalCarbs")
                userDefaults.set(self.totalProtein, forKey: "totalProtein")
                userDefaults.set(self.totalFats, forKey: "totalFats")
                userDefaults.synchronize()

            }
            self.tableView.reloadData()
                print(self.totalCalories)
                print(self.totalCarbs)
                print(self.totalProtein)
                print(self.totalFats)
            }
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Calories"
            textField.keyboardType = .numberPad
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Carbs"
            textField.keyboardType = .numberPad
            
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Protein"
            textField.keyboardType = .numberPad
            
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Fats"
            textField.keyboardType = .numberPad
            
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    func resetGoals(){
        
        let defaults = UserDefaults.standard
        let today = Date()
        let currentMonth = Calendar.current.component(.month, from: today)
        let currentDay = Calendar.current.component(.day, from: today)
        //let currentDay = 20
        let currentYear = Calendar.current.component(.year, from: today)
        let goalMonth = defaults.integer(forKey: "userMonth")
        let goalDay = defaults.integer(forKey: "userDay")
        let goalYear = defaults.integer(forKey: "userYear")
        if goalYear == 0 && goalMonth == 0 && goalDay == 0 {
            //goals empty
            let alert = UIAlertController(title: "Goals Empty", message: "Set macros goals daily", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Got it", style: .cancel) { (_) in }
            self.totalCalories = 0
            self.totalCarbs = 0
            self.totalProtein = 0
            self.totalFats = 0
            defaults.set(0, forKey: "totalCalories")
            defaults.set(0, forKey: "totalCarbs")
            defaults.set(0, forKey: "totalProtein")
            defaults.set(0, forKey: "totalFats")
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if goalYear == currentYear && goalMonth == currentMonth && goalDay == currentDay {
            return
        }
        else {
            let alert = UIAlertController(title: "New Day", message: "Make sure to set new goals for the day", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Got it", style: .cancel) { (_) in }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            defaults.set(0, forKey: "userMonth")
            defaults.set(0, forKey: "userDay")
            defaults.set(0, forKey: "userYear")
            defaults.set(0, forKey: "userCal")
            defaults.set(0, forKey: "userCarb")
            defaults.set(0, forKey: "userProte")
            defaults.set(0, forKey: "userFat")
            defaults.set(0, forKey: "totalCalories")
            defaults.set(0, forKey: "totalCarbs")
            defaults.set(0, forKey: "totalProtein")
            defaults.set(0, forKey: "totalFats")
        }
    
        
    }
    
    
    func resetMeals() {
        
        let defaults = UserDefaults.standard
        let today = Date()
        let currentMonth = Calendar.current.component(.month, from: today)
        let currentDay = Calendar.current.component(.day, from: today)
        //let currentDay = 20
        let currentYear = Calendar.current.component(.year, from: today)
        
        if let decoded: Data = defaults.object(forKey: "meals") as? Data {
            let decodedMeals = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Meal]
            let firstMealDay = decodedMeals[0].day
            let firstMealMonth = decodedMeals[0].month
            let firstMealYear = decodedMeals[0].year
            
            if firstMealYear == currentYear && firstMealMonth == currentMonth && firstMealDay == currentDay {
                //leave meals alone
                return
            }
            else {
                
                
                //new day remove old meals
                self.meals.removeAll()
                self.totalCalories = 0
                self.totalCarbs = 0
                self.totalProtein = 0
                self.totalFats = 0
                defaults.set(0, forKey: "totalCalories")
                defaults.set(0, forKey: "totalCarbs")
                defaults.set(0, forKey: "totalProtein")
                defaults.set(0, forKey: "totalFats")
                
//                defaults.set(0, forKey: "userMonth")
//                defaults.set(0, forKey: "userDay")
//                defaults.set(0, forKey: "userYear")
//                defaults.set(0, forKey: "userCal")
//                defaults.set(0, forKey: "userCarb")
//                defaults.set(0, forKey: "userProte")
//                defaults.set(0, forKey: "userFat")
            }

        }
          //  else {
//            defaults.set(0, forKey: "totalCalories")
//            defaults.set(0, forKey: "totalCarbs")
//            defaults.set(0, forKey: "totalProtein")
//            defaults.set(0, forKey: "totalFats")
//            
//        }
        
               
        
    }
    
    func setUpConstraints(){
        //label
        currentDayLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5).isActive = true
        currentDayLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
        currentDayLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 75).isActive = true
        currentDayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //button
        seeMacrosButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
       seeMacrosButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        seeMacrosButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        seeMacrosButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -75).isActive = true
        
        tableView.topAnchor.constraint(equalTo: currentDayLabel.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: seeMacrosButton.topAnchor).isActive = true
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DailyTableViewCell(style: .default, reuseIdentifier: "myCell")
        let defaults = UserDefaults.standard
        let decoded  = defaults.object(forKey: "meals") as! Data
        let decodedMeals = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Meal]
        cell.label.text = labelsForRows[indexPath.row]
        if (labelsForRows[indexPath.row] == "Calories"){
            if let mealCal = decodedMeals[indexPath.section].calories  {
                cell.value.text = String(mealCal)
                
            }
            
            
        }
        else if (labelsForRows[indexPath.row] == "Carbohydrates"){
            if let mealCarb = decodedMeals[indexPath.section].carbohydrates {
                cell.value.text = String(mealCarb)
            }
            
        }
        else if (labelsForRows[indexPath.row] == "Protein"){
            if let mealProtein = decodedMeals[indexPath.section].protein  {
                cell.value.text = String(mealProtein)
            }
            
        }
        else if (labelsForRows[indexPath.row] == "Fat"){
            if let mealFats = decodedMeals[indexPath.section].fats  {
                cell.value.text = String(mealFats)
            }
        }
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.meals.count
        }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var str = ""
        str = sectionHeader + String(section+1)
        
        return str
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let frame: CGRect = self.view.frame
        
        let button = UIButton(frame: CGRect(x: frame.size.width-120, y: -10, width: 150, height: 50))
        button.setTitle("Remove", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleRemoveMeal), for: .touchUpInside)
        button.tag = section
        
        var label: UILabel = UILabel(frame: CGRect(x: 10, y: -10, width: 75, height: 50))
        label.text = sectionHeader + String(section+1)
        
        
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        headerView.backgroundColor = UIColor.lightGray
        headerView.addSubview(button)
        headerView.addSubview(label)
        return headerView
        
        
        
        
        
        

    }
    
    func handleRemoveMeal(button: UIButton){
        print("Remove meal")
       let defaults = UserDefaults.standard
        var section = button.tag
        self.totalCalories -= self.meals[section].calories!
        self.totalCarbs -= self.meals[section].carbohydrates!
        self.totalProtein -= self.meals[section].protein!
        self.totalFats -= self.meals[section].fats!
        defaults.set(self.totalCalories, forKey: "totalCalories")
        defaults.set(self.totalCarbs, forKey: "totalCarbs")
        defaults.set(self.totalProtein, forKey: "totalProtein")
        defaults.set(self.totalFats, forKey: "totalFats")
        
        self.meals.remove(at: section)
        
        var array = [Int]()
        array.append(section)
        let indexSet = IndexSet(array)
        
        tableView.deleteSections(indexSet, with: .fade)
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
}
class DailyTableViewCell: UITableViewCell {
    var label: UILabel! = UILabel()
    var value: UILabel! = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        label.frame = CGRect(x: 15, y: 10,width: 150,height: 25)
        value.frame = CGRect(x: 250, y: 10, width: 70, height: 25)
        label.textColor = UIColor.black
        value.textColor = UIColor.black
        contentView.addSubview(label)
        contentView.addSubview(value)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    }





