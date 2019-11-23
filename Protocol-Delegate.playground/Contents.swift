import Cocoa

protocol EmployeeDelegate: AnyObject { // 员工协议
    func PunchAction(date: Date)
}

class Employee { // 员工类
    weak var delegate : EmployeeDelegate?
    
    // 打卡
    func punchAction() {
        delegate?.PunchAction(date: Date())
    }
}

class Company : EmployeeDelegate { // 公司类
    
    var employee1 : Employee?
    
    init() {
        employee1 = Employee()
        employee1?.delegate = self
    }
    
    func allPunchAction() {
        employee1?.punchAction()
    }
    
    // 若有员工打卡
    func PunchAction(date: Date) {
        defer {
            print("方法结束执行")
        }
        print(date)
    }
}

var company = Company()
company.allPunchAction()
