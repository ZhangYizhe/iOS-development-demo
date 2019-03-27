import UIKit

enum errorType : Error {
    case failureReason1
    case failureReason2
}

func test() -> Result<String, errorType> {
//    return .success("成功啦")
    return .failure(.failureReason1)
}

switch test() {
case let .success(result):
    print(result)
case let .failure(error):
    switch error {
    case .failureReason1:
        print("错误原因1")
    case .failureReason2:
        print("错误原因2")
    @unknown default:
        break
    }
}
