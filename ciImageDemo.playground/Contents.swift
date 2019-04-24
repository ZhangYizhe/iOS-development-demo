//: A Cocoa based Playground to present user interface

import AppKit
import PlaygroundSupport

//let nibFile = NSNib.Name("MyView")
//var topLevelObjects : NSArray?
//
//Bundle.main.loadNibNamed(nibFile, owner:nil, topLevelObjects: &topLevelObjects)
//let views = (topLevelObjects as! Array<Any>).filter { $0 is NSView }
//
//// Present the view in Playground
//PlaygroundPage.current.liveView = views[0] as! NSView


import CoreImage

let myURL = "/Users/zhangyizhe/Desktop/test.jpg"

let originalImage = NSImage(contentsOf: URL(fileURLWithPath: myURL))

let imageData = originalImage?.tiffRepresentation


let context = CIContext()                                           // 1

let filter = CIFilter(name: "CIGaussianBlur")!                         // 2
filter.setValue(1, forKey: kCIInputImageKey)

let image = CIImage(data: imageData!)
// 3
filter.setValue(image, forKey: kCIInputImageKey)
let result = filter.outputImage!                                    // 4
let cgImage = context.createCGImage(result, from: result.extent)    // 5

extension CIImage: CustomPlaygroundDisplayConvertible {
    static let playgroundRenderContext = CIContext()
    public var playgroundDescription: Any {
        let jpgData = CIImage.playgroundRenderContext.jpegRepresentation(of: self, colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, options: [:])!
        return NSImage(data: jpgData)!
    }
}
