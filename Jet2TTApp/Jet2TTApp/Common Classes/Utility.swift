//
//  Utility.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func randomColor() -> UIColor {
        return UIColor(red: (Int.randomNumberLessThan250() / 255.0),
                       green: (Int.randomNumberLessThan250() / 255.0),
                       blue: (Int.randomNumberLessThan250() / 255.0),
                       alpha: 0.9)
    }
    
    class func colorFromHex(rgbValue:UInt32, alpha:Double = 1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}

extension Int {
    static func randomNumberLessThan250() -> CGFloat {
        return CGFloat(Int.random(in: 0...250))
    }
}

extension UIStoryboard {
    
    class func instantiateViewcontroller<T>(ofType type: T.Type,
                                            fromStoryboard storyBoardName: String = "Main",
                                            andBundle bundle: Bundle = .main) -> UIViewController {
        return UIStoryboard(name: storyBoardName, bundle: bundle).instantiateViewController(withIdentifier: String(describing: type))
    }
}

extension UIImageView {
    
    func loadImage(at url: URL) {
        UIImageLoader.loader.load(url, for: self)
    }
    
    func cancelImageLoad() {
        UIImageLoader.loader.cancel(for: self)
    }
}

func readDummyJSONResonse() -> Data? {
    Bundle.main.url(forResource: "employee", withExtension: "json").map { jsonURL in
        return try! Data(contentsOf: jsonURL)
    }
}

typealias UIAlertControllerHandler = ( _ alertController: UIAlertController, _ selectedIndex: Int ) -> Void

extension UIViewController {
    func showAlert(title: String, message: String, buttonTitles: [String] = ["OK"], handler: UIAlertControllerHandler?) {
        let controller = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let actionHandler = { action  -> Void in
            handler?( controller, controller.actions.firstIndex(of: action ) ?? -1 )
        }
        for title in buttonTitles[ 0..<buttonTitles.count ] {
            controller.addAction( UIAlertAction( title: title, style: .default, handler: actionHandler))
        }
        self.present(controller, animated: true, completion: nil)
    }
}

extension UIAlertController {
    
    class func showAlert(inParent parent: UIViewController,
                         preferredStyle style: Style,
                         withTitle title: String,
                         alertMessage message: String,
                         andAlertActions actions: [UIAlertAction]?) {
        
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: style)
        
        if let alertActions = actions {
            _ = alertActions.map{ alertVC.addAction($0) }
        }
        
        parent.popoverPresentationController?.sourceView = parent.view
        parent.popoverPresentationController?.sourceRect = CGRect(x: parent.view.bounds.width / 2.0,
                                                                  y: parent.view.bounds.height / 2.0,
                                                                  width: 1.0,
                                                                  height: 1.0)
        
        parent.present(alertVC, animated: true, completion: nil)
    }
}
