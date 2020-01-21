//
//  ViewController.swift
//  PocketSVGRegionSelection
//
//  Created by Komal Goyani on 21/01/20.
//  Copyright © 2020 IBL INFOTECH. All rights reserved.
//

import UIKit
import PocketSVG

class ViewController: UIViewController {

    var affineTransform = CGAffineTransform()
    let countryLayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderSVG()
    }

    func renderSVG() {
        view.backgroundColor = .white
        let url = Bundle.main.url(forResource: "in", withExtension: "svg")!
        let svgImageView = SVGImageView.init(contentsOf: url)
        svgImageView.frame = view.bounds
        svgImageView.contentMode = .scaleAspectFit
//        view.addSubview(svgImageView) // For showing in imageview
        
        let paths = SVGBezierPath.pathsFromSVG(at: url)
        
        for (index, path) in paths.enumerated() {
            let shapeLayer = CAShapeLayer()
            shapeLayer.fillColor = UIColor(hue: CGFloat(index)/CGFloat(paths.count), saturation: 1, brightness: 1, alpha: 1).cgColor
            shapeLayer.strokeColor = UIColor(white: 1-CGFloat(index)/CGFloat(paths.count), alpha: 1).cgColor
            // for blank & white map
//            shapeLayer.fillColor = UIColor.white.cgColor
//            shapeLayer.strokeColor = UIColor.black.cgColor
            shapeLayer.lineWidth = 2.0
            
            shapeLayer.path = path.cgPath // copy path
            
            print("\(path.svgAttributes)")
            if let name = path.svgAttributes["name"] {
                print("\(path.svgAttributes["id"]!): \(name)")
                shapeLayer.accessibilityLabel = name as? String
            }
            
            countryLayer.addSublayer(shapeLayer) // add sublayer(region) in main layer
            
            // Stroke draw animation
            let animation = CABasicAnimation(keyPath:"strokeEnd")
            animation.duration = 4.0
            animation.fromValue = 0.0
            animation.toValue = 1.0
            animation.fillMode = CAMediaTimingFillMode.forwards
            animation.isRemovedOnCompletion = false
            shapeLayer.add(animation, forKey: "strokeEndAnimation")
        }

        let scale = CGAffineTransform(scaleX: 0.3, y: 0.3)
        let transform = CGAffineTransform(translationX: 100, y: 100)
        affineTransform = scale.concatenating(transform)
        countryLayer.setAffineTransform(affineTransform)
        view.layer.addSublayer(countryLayer)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self.view).applying(affineTransform.inverted())

            for layer in self.view.layer.sublayers! {
                for sublayer in layer.sublayers! {
                    if let shapeLayer = sublayer as? CAShapeLayer {
                        if shapeLayer.path!.contains(touchLocation) {
                            print("touched the shape layer: \(shapeLayer.accessibilityLabel ?? "")")
                            
                        }
                    }
                }
            }
        }
    }
}

