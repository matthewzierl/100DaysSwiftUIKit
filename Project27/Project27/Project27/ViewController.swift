//
//  ViewController.swift
//  Project27
//
//  Created by Matthew Zierl on 8/31/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        drawRectangle()
    }

    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if (currentDrawType > 7) {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawCheckerboard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        case 6:
            drawSurprisedFace()
        case 7:
            drawTWIN()
        default:
            break
        }
    }
    
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512)) // points, not pixels
        
        let image = renderer.image { context in
            // awesome drawing code
            
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5) // bring in by 5
            // explanation: line width of 10 centers on border, so 5 points in, 5 points out, making it cut off by rectangle
            
            context.cgContext.setFillColor(UIColor.red.cgColor)
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.setLineWidth(10)
            
            context.cgContext.addRect(rectangle) // add rectangle
            context.cgContext.drawPath(using: .fillStroke) // fill rectangle, AND stroke around border
        }
        
        imageView.image = image
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512)) // points, not pixels
        
        let image = renderer.image { context in
            // awesome drawing code
            
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            context.cgContext.setFillColor(UIColor.red.cgColor)
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.setLineWidth(10)
            
            context.cgContext.addEllipse(in: rectangle) // ellipse needs to fit within bounds of rect
            context.cgContext.drawPath(using: .fillStroke) // fill rectangle, AND stroke around border
        }
        
        imageView.image = image
    }
    
    func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512)) // points, not pixels
        
        let image = renderer.image { context in
            // awesome drawing code
            context.cgContext.setFillColor(UIColor.black.cgColor)
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col) % 2 == 0 {
                        context.cgContext.fill(CGRect(x: row * 64, y: col * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = image
    }
    
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512)) // points, not pixels
        
        let image = renderer.image { context in
            // awesome drawing code
            context.cgContext.translateBy(x: 256, y: 256)
            let rotations = 16
            let amount = Double.pi / Double(16)
            
            for _ in 0 ..< rotations {
                context.cgContext.rotate(by: CGFloat(amount))
                context.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512)) // points, not pixels
        
        let image = renderer.image { context in
            // awesome drawing code
            context.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                context.cgContext.rotate(by: .pi / 2)
                
                if first {
                    context.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    context.cgContext.addLine(to: CGPoint(x: length, y: 50))
                    length *= 0.99
                }
            }
            
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512)) // points, not pixels
        
        let image = renderer.image { context in
            // awesome drawing code
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle,
            ]
            
            let string = "I need a job please help me. Also I miss Japan..."
            
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        
        imageView.image = image
    }
    
    func drawSurprisedFace() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512)) // points, not pixels
        
        let image = renderer.image { context in
            // awesome drawing code
            
            // face
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            context.cgContext.setFillColor(UIColor.yellow.cgColor)
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.setLineWidth(10)
            
            context.cgContext.addEllipse(in: rectangle) // ellipse needs to fit within bounds of rect
            context.cgContext.drawPath(using: .fillStroke) // fill rectangle, AND stroke around border
            
            // eyes
            let leftEyeRect = CGRect(x: 140, y: 150, width: 100, height: 100).insetBy(dx: 5, dy: 5)
            
            context.cgContext.setFillColor(UIColor.darkGray.cgColor)
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.setLineWidth(5)
            
            context.cgContext.addEllipse(in: leftEyeRect) // ellipse needs to fit within bounds of rect
            context.cgContext.drawPath(using: .fillStroke) // fill rectangle, AND stroke around border
            
            let rightEyeRect = CGRect(x: 300, y: 150, width: 100, height: 100).insetBy(dx: 5, dy: 5)
            
            context.cgContext.setFillColor(UIColor.darkGray.cgColor)
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.setLineWidth(5)
            
            context.cgContext.addEllipse(in: rightEyeRect) // ellipse needs to fit within bounds of rect
            context.cgContext.drawPath(using: .fillStroke) // fill rectangle, AND stroke around border
            
            // mouth
            let mouthRect = CGRect(x: 200, y: 320, width: 150, height: 150).insetBy(dx: 5, dy: 5)
            
            context.cgContext.setFillColor(UIColor.darkGray.cgColor)
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.setLineWidth(5)
            
            context.cgContext.addEllipse(in: mouthRect) // ellipse needs to fit within bounds of rect
            context.cgContext.drawPath(using: .fillStroke) // fill rectangle, AND stroke around border
            
        }
        
        imageView.image = image
    }
    
    func drawTWIN() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512)) // points, not pixels
        
        let image = renderer.image { context in
            // awesome drawing code
            
            context.cgContext.move(to: CGPoint(x: 0, y: 100))
            context.cgContext.addLine(to: CGPoint(x: 200, y: 100))
            context.cgContext.move(to: CGPoint(x: 100, y: 100))
            context.cgContext.addLine(to: CGPoint(x: 100, y: 400))
            
            context.cgContext.move(to: CGPoint(x: 300, y: 100))
            context.cgContext.addLine(to: CGPoint(x: 500, y: 100))
            context.cgContext.addLine(to: CGPoint(x: 300, y: 400))
            context.cgContext.addLine(to: CGPoint(x: 500, y: 400))
            
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.setLineWidth(10)
            context.cgContext.strokePath()
        }
        
        imageView.image = image
    }
}

