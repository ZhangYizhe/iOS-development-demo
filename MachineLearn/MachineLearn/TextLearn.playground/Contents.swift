import Foundation
import CreateML

let trainSet = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/zhangyizhe/Documents/iosdevelop/Demo/MachineLearn/data.json"))
let model = try MLTextClassifier(trainingData: trainSet, textColumn: "text", labelColumn: "label")

model.trainingMetrics

let testSet = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/zhangyizhe/Documents/iosdevelop/Demo/MachineLearn/data.json"))
let res = model.evaluation(on: testSet)

let writeToUrl = URL(fileURLWithPath: "/Users/zhangyizhe/Documents/iosdevelop/Demo/MachineLearn/TextClassifier.mlmodel")
try model.write(to: writeToUrl)
