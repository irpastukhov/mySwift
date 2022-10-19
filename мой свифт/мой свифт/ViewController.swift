//
//  ViewController.swift
//  мой свифт
//
//  Created by Ivan Pastukhov on 09.09.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var changeTF: UITextField!
    @IBOutlet weak var myViewWithStackView: UIView!
    @IBOutlet weak var passedLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var debtLabel: UILabel!
    @IBOutlet var minusAndPlusButtons: [UIButton]!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    
    
    private let userDefaults = UserDefaults.standard
    
    private var allData1 = [DataModel]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.layer.masksToBounds = true
        nameLabel.layer.cornerRadius = 13
        myViewWithStackView.layer.cornerRadius = 20
        
        changeTF.attributedPlaceholder = NSAttributedString(
            string: "Add",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        for i in minusAndPlusButtons {
            i.isHidden = true
        }
        
        retrieveUserDefaults()
        debtUpdate()
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        changeTF.resignFirstResponder()
        for i in minusAndPlusButtons {
            i.isHidden = true
        }
        changeTF.text?.removeAll()
    }
    
    @IBAction func changeTFAction(_ sender: UITextField) {
        for i in minusAndPlusButtons {
            i.isHidden = false
        }
    }
    
    @IBAction func minusAndPlusButtonsAction(_ sender: UIButton) {
        
        changeTF.resignFirstResponder()
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        guard let changeFTText = changeTF.text, let number = formatter.number(from: changeFTText) else { return }
        let a = number.floatValue
        guard a > 0 else { return }
        
        let passedLabelСonverted = Float(passedLabel.text!)!
        let leftLabelСonverted = Float(leftLabel.text!)!
        
        switch sender.tag {
        case 0:
            passedLabel.text = "\(passedLabelСonverted - a)"; leftLabel.text = "\(leftLabelСonverted + a)"
        case 1:
            passedLabel.text = "\(passedLabelСonverted + a)"; leftLabel.text = "\(leftLabelСonverted - a)"
            saveTheTimeAndHours(hours: a)
        default:
            break
        }
        
        intOrFloat(textNumber: &passedLabel.text!)
        intOrFloat(textNumber: &leftLabel.text!)
        intOrFloat(textNumber: &debtLabel.text!)
        
        userDefaults.set(passedLabel.text, forKey: "passedLabelText")
        userDefaults.set(leftLabel.text, forKey: "leftLabelText")
        
        changeTF.text?.removeAll()
        
        for i in minusAndPlusButtons {
            i.isHidden = true
        }
        debtUpdate()
    }
    
    //MARK: - Converting a number to an integer if it has no remainder
    private func intOrFloat(textNumber: inout String) {
        if Float(textNumber)! == Float(round(Float(textNumber)!)) {
            textNumber = String(Int(round(Float(textNumber)!)))
        }
    }
    
    
    
    //MARK: - saveTheTimeAndHours
    private func saveTheTimeAndHours(hours: Float) {
        guard hours > 0 else { return }
        
        let dataHours = hourOrHours(hours: hours)
        
        
        let dateUTC = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd.M.yyyy"
        let dataDate = dateFormatter.string(from: dateUTC)
        dateFormatter.dateFormat = "HH:mm"
        let dataTime = dateFormatter.string(from: dateUTC)
        
        if allData1.isEmpty {
            let arr = DataModel(date: dataDate, time: [dataTime], hours: [dataHours], hoursSum: hours)
            allData1.insert(arr, at: 0)
        } else if allData1[0].date == dataDate {
            allData1[0].time.insert(contentsOf: [dataTime], at: 0)
            allData1[0].hours.insert(contentsOf: [dataHours], at: 0)
            allData1[0].hoursSum += hours
        }  else if allData1[0].date != dataDate {
            let arr = DataModel(date: dataDate, time: [dataTime], hours: [dataHours], hoursSum: hours)
            allData1.insert(arr, at: 0)
        }

        
        do {
            try userDefaults.setObject(allData1, forKey: "allData1Saved")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - prepareForSegue and unwindSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "showTimeAndHours" else { return }
        let navigationVC = segue.destination as! UINavigationController
        let myTableViewController = navigationVC.topViewController as! MyTableViewController
        myTableViewController.allData2 = allData1
        
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
    }
    
    //MARK: - debtUpdate
    private func debtUpdate() {
        guard !allData1.isEmpty else { return }
        let dateUTC = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd.M.yyyy"
        let dateNowString = dateFormatter.string(from: dateUTC)
        
        notificationLabel.text = "6 hours left for today"
        guard dateNowString == allData1[0].date else { return }
        if allData1[0].hoursSum == 6 {
            notificationLabel.text = "Everything is done for today!"
        } else if allData1[0].hoursSum > 6 {
            notificationLabel.text = "Done even more than needed!"
        } else if allData1[0].hoursSum < 6 {
            let hours = 6 - allData1[0].hoursSum
           let hoursData = hourOrHours(hours: hours)
            notificationLabel.text = "\(hoursData) left for today"
        }
        
//        guard dateNowString != allData1[0].date else { return }
//        let dateNow = dateFormatter.date(from: dateNowString)
//        let lastDate = dateFormatter.date(from: allData1[0].date)
//        let result = dateNow!.timeIntervalSince(lastDate!)  / 24 / 60 / 60
    }
    
    //MARK: - hourOrHours
    private func hourOrHours(hours: Float) -> String {
        var endingOfHours = "hours"
        if hours == 1 {
            endingOfHours = "hour"
        }

        var dataHours: String
        if hours == Float(round(hours)) {
            let hours2 = Int(round(hours))
            dataHours = "\(hours2) \(endingOfHours)"
        } else {
            dataHours = "\(hours) \(endingOfHours)"
        }
        return dataHours
    }
    
    //MARK: - retrieveUserDefaults
    private func retrieveUserDefaults() {
        guard let passedLabelText = userDefaults.object(forKey: "passedLabelText") else { return }
        passedLabel.text = passedLabelText as? String
        guard let leftLabelText = userDefaults.object(forKey: "leftLabelText") else { return }
        leftLabel.text = leftLabelText as? String
        
        do {
            let allData1Saved = try userDefaults.getObject(forKey: "allData1Saved", castTo: [DataModel].self)
            allData1 = allData1Saved
        } catch {
            print(error.localizedDescription)
        }
    }
    
}






//MARK: - New protocol for adding customized objects to userDefaults
protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}
