//
//  ViewController.swift
//  fengNplServer
//
//  Created by Yizhe.Zhang on 2019/1/9.
//  Copyright © 2019 cn.yygdz. All rights reserved.
//

import Cocoa
import Swifter

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        do {
            let server = demoServer(try String.File.currentWorkingDirectory())
            server["/testAfterBaseRoute"] = { request in
                return .ok(.html("ok !"))
            }
            
            if #available(OSXApplicationExtension 10.10, *) {
                try server.start(9080, forceIPv4: true)
            } else {
                // Fallback on earlier versions
            }
            
            print("Server has started ( port = \(try server.port()) ). Try to connect now...")
            
            RunLoop.main.run()
            
        } catch {
            print("Server start error: \(error)")
        }
        
        
        return
        

        let mlmodel = processmessagefilter()
        
        let server = HttpServer()
        server[""] = { request in
            let content = request.queryParams.first?.1
            if content == nil {
                return HttpResponse.ok(.text("123"))
            }
            
            guard let output = try? mlmodel.prediction(text: content ?? "") else {
                return HttpResponse.ok(.text("Unexpected runtime error."))
            }
    
            
            return HttpResponse.ok(.text("<meta http-equiv='Content-Type' content='text/html; charset=utf-8' /> 您传入的内容是：\(content ?? "")<br>该内容我认为是：\(output.label)"))
        }
        do {
            try server.start(80, forceIPv4: true)
            print()
            print("Server has started ( port = \(try server.port()) ). Try to connect now...")
        } catch {
            print("Server start error: \(error)")
        }
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

