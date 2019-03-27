import UIKit

// 传统方法
func oldFunc(completion: (Bool) -> Void) {
    completion(true)
}

oldFunc { (status) in
    print(status)
}


//Siwft5新方法
//func newFunc() async -> String {
//    return "12323"
//}
//
//newFunc()

var ii:Int = 0
let jj:Int8 = 1
ii = numericCast(jj)
print(ii)
