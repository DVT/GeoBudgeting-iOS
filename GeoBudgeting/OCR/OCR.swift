//
//  OCR.swift
//  GeoBudgeting
//
//  Created by Prateek Kambadkone on 2019/05/07.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import UIKit

// Create request
func ocr (cameraImage: UIImage) {
    let baseUrl = "https://www.ocrwebservice.com/restservices/processDocument",
    params = "?language=english&gettext=true&outputformat=txt&newline=1",
    requestUrl = NSURL(string: "\(baseUrl)\(params)"),
    request = NSMutableURLRequest(url:requestUrl! as URL)
    request.httpMethod = "POST";
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
    
    //let imageData: Data = (UIImage(named: "receipt")?.pngData())!
    let imageData: Data = cameraImage.pngData()!
    request.httpBodyStream = InputStream(data: imageData)
    // Create session configuration (for authentication)
    let config = URLSessionConfiguration.default,
    userPasswordString = "\(getOCRKey().0):\(getOCRKey().1)",
    userPasswordData = userPasswordString.data(using: String.Encoding.utf8),
    base64EncodedCredential = userPasswordData!.base64EncodedString(options: .init()),
    authString = "Basic \(base64EncodedCredential)"
    request.setValue(authString, forHTTPHeaderField: "Authorization")
    // Create session
    let session = URLSession(configuration: config)
    // Set up task for execution
    print(config)
    let task = session.dataTask(with: request as URLRequest) {
        data, response, error in
        if error != nil
        {
            print("error=\(error)")
            return
        }
        let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print("response = \(response)")
        print("dataString = \(dataString)")
        //Convert response sent from a server side script to a NSDictionary object:
        var err: Error?
        do {
            let myJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves)  as? NSDictionary
            if let parseJSON = myJSON {
                // Now we can access values of the data object by their keys
                var availPages = parseJSON["AvailablePages"] as? Int
                var OCRText = (parseJSON["OCRText"] as? NSArray)
                print("Available Pages: \(availPages!)")
                print("OCRText: \(OCRText!)")
            }
        } catch let error {
            print(error)
        }
    }
    task.resume()
}
