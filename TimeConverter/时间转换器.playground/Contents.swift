import UIKit


// 时间转换器
func TimeConverter(InputTimestap : Int) -> String{
    let nowTimeDetial = timeDetialGet(timestamp: NowTimestamp())
    let inputTimeDetial = timeDetialGet(timestamp: InputTimestap)
    
    if nowTimeDetial.year == inputTimeDetial.year { // 判断是否为当年
        let monthDifference = nowTimeDetial.month - inputTimeDetial.month // 当前时间大于输入时间为 正
        var dayDifference = 0 // 当前时间大于输入时间为 正
        
        if monthDifference == 1 {
            dayDifference = nowTimeDetial.day + (MonthToDay(year: inputTimeDetial.year, month: inputTimeDetial.month) - inputTimeDetial.day)
        } else if monthDifference == 0 {
            dayDifference = nowTimeDetial.day - inputTimeDetial.day
        } else {
            return "\(inputTimeDetial.month)-\(inputTimeDetial.day) \(completionNumString(_in: inputTimeDetial.hour)):\(completionNumString(_in: inputTimeDetial.minutes))" // 时间间隔大于一个月 或 输入时间比当前时间
        }
        
        if dayDifference < 0 { // 当前时间小于输入时间
            return "\(inputTimeDetial.year)-\(inputTimeDetial.month)-\(inputTimeDetial.day) \(inputTimeDetial.hour):\(completionNumString(_in: inputTimeDetial.minutes))"
        }
        
        if dayDifference == 0 { // 今天
            if nowTimeDetial.hour > inputTimeDetial.hour {
                return "\(completionNumString(_in: inputTimeDetial.hour)):\(completionNumString(_in: inputTimeDetial.minutes))"
            } else if nowTimeDetial.hour == inputTimeDetial.hour{
                if nowTimeDetial.minutes > inputTimeDetial.minutes {
                    return "\(nowTimeDetial.minutes - inputTimeDetial.minutes)分钟前"
                } else if nowTimeDetial.minutes == inputTimeDetial.minutes {
                    return "刚刚"
                }
            }
        } else if dayDifference == 1 {
            return "昨天\(completionNumString(_in: inputTimeDetial.hour)):\(completionNumString(_in: inputTimeDetial.minutes))"
        } else {
            return "\(inputTimeDetial.month)-\(inputTimeDetial.day) \(completionNumString(_in: inputTimeDetial.hour)):\(completionNumString(_in: inputTimeDetial.minutes))" // 时间间隔大于一个月 或 输入时间比当前时间
        }
        
    }
    
    return "\(inputTimeDetial.year)-\(inputTimeDetial.month)-\(inputTimeDetial.day) \(completionNumString(_in: inputTimeDetial.hour)):\(completionNumString(_in: inputTimeDetial.minutes))"
}



// 当前时间 时间戳
private func NowTimestamp() -> Int {
    let timeInterval:TimeInterval = Date().timeIntervalSince1970
    let timeStamp = Int(timeInterval)
    return timeStamp
}

// MARK: - 年月日具体
// 年月日结构体
struct TimeDetialStruct {
    var year : Int
    var month : Int
    var day : Int
    var hour : Int
    var minutes : Int
    var second : Int
    var timestamp : Int
}

// 年月日具体时间转换
private func timeDetialGet(timestamp: Int) -> TimeDetialStruct {
    
    var timeDetialStruct = TimeDetialStruct(year: 1, month: 1, day: 1, hour: 1, minutes: 1, second: 1, timestamp: 1)
    
    //转换为时间
    let timeInterval:TimeInterval = TimeInterval(timestamp)
    let date = Date(timeIntervalSince1970: timeInterval)
    
    //年格式器
    let yearformatter = DateFormatter()
    yearformatter.dateFormat = "yyyy"
    
    //月格式器
    let monthformatter = DateFormatter()
    monthformatter.dateFormat = "MM"
    
    //日格式器
    let dayformatter = DateFormatter()
    dayformatter.dateFormat = "dd"
    
    //时格式器
    let hourformatter = DateFormatter()
    hourformatter.dateFormat = "HH"
    
    //分格式器
    let minutesformatter = DateFormatter()
    minutesformatter.dateFormat = "mm"
    
    //秒格式器
    let secondformatter = DateFormatter()
    secondformatter.dateFormat = "ss"
    
    timeDetialStruct.year = Int(yearformatter.string(from: date)) ?? 1
    timeDetialStruct.month = Int(monthformatter.string(from: date)) ?? 1
    timeDetialStruct.day = Int(dayformatter.string(from: date)) ?? 1
    timeDetialStruct.hour = Int(hourformatter.string(from: date)) ?? 1
    timeDetialStruct.minutes = Int(minutesformatter.string(from: date)) ?? 1
    timeDetialStruct.second = Int(secondformatter.string(from: date)) ?? 1
    timeDetialStruct.timestamp = timestamp
    
    return timeDetialStruct
}

// MARK: - 每月具体天数换算器
private func MonthToDay(year: Int, month: Int) -> Int{
    switch month {
    case 1,3,5,7,8,10,12:
        return 31
    case 4,6,9,11:
        return 31
    case 2:
        if year % 4 == 0 && year % 100 != 0 { //普通闰年
            return 29
        } else if year % 400 == 0 { // 世纪闰年
            return 29
        }
        return 28
    default:
        return 0
    }
}

// MARK: - 数字补偿器
private func completionNumString(_in: Int) -> String {
    if _in <= 9 {
        return "0\(_in)"
    }
    return "\(_in)"
}



struct timeStr {
    var time : Int
    var timeStr : String
    
    //    init() {
    //        self.time = ""
    //        self.timeStr = ""
    //    }
}


var timeArr : [timeStr] = []

timeArr.append(timeStr(time: 1552964119, timeStr: ""))
timeArr.append(timeStr(time: 1552958068, timeStr: ""))
timeArr.append(timeStr(time: 1552958068, timeStr: ""))
timeArr.append(timeStr(time: 1552958067, timeStr: ""))
timeArr.append(timeStr(time: 1552896000, timeStr: ""))
timeArr.append(timeStr(time: 1552958065, timeStr: ""))
timeArr.append(timeStr(time: 1511918064, timeStr: ""))

for (k,v) in timeArr.enumerated() {
    if k-1 > 0 && TimeConverter(InputTimestap: timeArr[k].time) == timeArr[k-1].timeStr {
        timeArr[k-1].timeStr = ""
        timeArr[k].timeStr = TimeConverter(InputTimestap: timeArr[k].time)
    } else {
        timeArr[k].timeStr = TimeConverter(InputTimestap: timeArr[k].time)
    }
    
}


print("处理结果\n")

for (k,v) in timeArr.enumerated() {
    print(k)
    print(v.time)
    print(v.timeStr)
}
