//
//  ViewController.swift
//  Calculate
//
//  Created by  Nika Shelman on 24.12.2024.
//


import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var butAC: UIButton!
    @IBOutlet weak var butRevers: UIButton! // +/-
    @IBOutlet weak var butDivision: UIButton! // деление
    @IBOutlet weak var butPercent: UIButton!
    @IBOutlet weak var but7: UIButton!
    @IBOutlet weak var but8: UIButton!
    @IBOutlet weak var but9: UIButton!
    @IBOutlet weak var but6: UIButton!
    @IBOutlet weak var but5: UIButton!
    @IBOutlet weak var but4: UIButton!
    @IBOutlet weak var but3: UIButton!
    @IBOutlet weak var but2: UIButton!
    @IBOutlet weak var but1: UIButton!
    @IBOutlet weak var but0: UIButton!
    @IBOutlet weak var butMultiplication: UIButton! // умножение
    @IBOutlet weak var butMinus: UIButton!
    @IBOutlet weak var butPlus: UIButton!
    @IBOutlet weak var butEqual: UIButton! // равно
    @IBOutlet weak var butPoint: UIButton!
    
    @IBOutlet weak var display: UILabel!
    

    
    var operation: String?
    
    // вместо подсчета двух операндов устанавливаю переменную, которая будет производить операции с любым количеством операндов
    var result: Double = 0
    var newNumberStarted = true
    
    
    lazy var buttons: [UIButton] = [butAC, butRevers, butDivision, butPercent, but7, but8, but9, but6, but5, but4, but3, but2, but1, but0, butMultiplication, butMinus, butPlus, butEqual, butPoint]
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in buttons {
            
            button.layer.cornerRadius = button.frame.size.height/2
        button.layer.shadowColor = UIColor.gray.cgColor
            button.layer.shadowOffset = CGSize(width: 5, height: 5)
            button.layer.shadowOpacity = 0.4
            button.layer.shadowRadius = 7
        
        let secondShadow = CAShapeLayer()
        secondShadow.path = UIBezierPath(roundedRect: button.bounds, cornerRadius: button.layer.cornerRadius).cgPath
            secondShadow.fillColor = button.backgroundColor?.cgColor
            secondShadow.shadowColor = UIColor.white.cgColor
            secondShadow.shadowOffset = CGSize(width: -7, height: -7) // Вторая тень смещается влево-вверх
            secondShadow.shadowOpacity = 0.8
            secondShadow.shadowRadius = 8
        
            button.layer.insertSublayer(secondShadow, at: 0)
                
                self.view.addSubview(button)
        
        }
    
        display.text = "0"
    
    }

    
    @IBAction func butACClick(_ sender: UIButton) {
        display.text = "0"
        operation = nil
        newNumberStarted = true
    }
    
    @IBAction func butReversClick(_ sender: Any) {
        
        if let text = display.text, let value = Double(text.replacingOccurrences(of: ",", with: ".")) {
            let newValue = -value
            updateDisplay(newValue)
        }
        
    }
    
    
    
    @IBAction func butPointClick(_ sender: UIButton) {
        
        guard let title = sender.currentTitle else { return }
        
        // если число <1, нажатие на запятую высветит на дисплее "0,"
        if newNumberStarted {
            display.text = "0"
        }
        
        // запрет на повторную запятую
        if newNumberStarted || !display.text!.contains(",") {
            display.text! += title
            newNumberStarted = false
        }
    }
    
    
    @IBAction func numberButtonClick(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        if let currentText = display.text,
           !currentText.contains(",") || title != "," {
            if currentText == "0" || newNumberStarted && title != "." {
                display.text = title
                newNumberStarted = false
            } else {
                display.text! += title
                }
            }
        }
    
    
    
    
    private func performOperation() {
        
        //Объясняю Swift, что он должен воспринимать запятую как точку, чтобы он мог производить расчеты с дробными числами
        if let text = display.text, let value = Double(text.replacingOccurrences(of: ",", with: ".")) {
            
            if let op = operation {
                
                switch op {
                
                case "+":
                    result += value
                case "-":
                    result -= value
                case "×":
                    result *= value
                case "÷":
                    if value == 0 {
                        display.text = "Ошибка"
                        operation = nil
                        newNumberStarted = true
                        return
                        
                    } else {
                        result /= value
                    }
               
                default:
                    break
                }
                
            } else {
                result = value
            }
            
            if !(operation == "÷" && value == 0) {
                updateDisplay(result)
            }
        }
    }

            
        // форматирую результат так, чтобы целочисленные значения высвечивались как Int, а дробные разделялись символом "," вместо точки и ограничивали значение 15-ю знаками после запятой. Так же говорю swift о том, что большие числа, имеющие разряды тысяч, миллионов и т. д. разделялись по разрядам пробелом, а не запятой, чтобы это не ломало вычислительный процесс. Тут же даю округление значению после запятой, чтобы не возникало ложных дробных значений
    
    private func updateDisplay(_ value: Double) {
        
        let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 15
            formatter.minimumFractionDigits = 0
            formatter.decimalSeparator = ","
            formatter.groupingSeparator = " "
        
        let roundedValue = Double(round(100000 * value) / 100000)
        
            if let formattedResult = formatter.string(from: NSNumber(value: roundedValue)) {
                display.text = formattedResult
            }
    }
    
    
    @IBAction func operationButtonClick(_ sender: UIButton) {
        
        guard let title = sender.currentTitle else { return }
               
        if title == "%" {
            
            if let text = display.text, let value = Double(text.replacingOccurrences(of: ",", with: ".")) {
                
                let onePercent = value / 100.0 * result
                
                if let lastOperation = operation {
                    switch lastOperation {
                                
                    case "+":
                        result += onePercent
                    case "-":
                        result -= onePercent
                    case "×":
                        result *= onePercent
                    case "÷":
                        if onePercent != 0 {
                            result /= onePercent
                        }
                    default:
                        break
                    }
                } 
                updateDisplay(onePercent)
            }
            operation = title
            newNumberStarted = true
            return
        } else {
            performOperation()
            operation = title
            newNumberStarted = true
        }
    }
    
    
    
    @IBAction func equalButtonClick(_ sender: UIButton) {
        
        performOperation()
        operation = nil
        
    }
    
}
    
    




