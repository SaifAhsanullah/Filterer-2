
import Foundation
import UIKit
import Darwin


class ImageFilter {
    var blueAvg = 0
    var redAvg = 0
    var greenAvg = 0
    var image: RGBAImage
    
    init(image: UIImage) {
        self.image = RGBAImage(image: image)!
    }
    
    func toUIImage() -> UIImage {
        return self.image.toUIImage()!
    }
    
    func applyFilter(_ filter: [String], value: Float){
        
        self.getAverages(self.image)
        
        //for option in filter {
        switch filter[0].lowercased() {
        case "redfilter":
            self.redFilter(self.image, value: value)
        case "greenfilter":
            self.Green(self.image, value: value)
        case "bluefilter":
            self.Blue(self.image, value: value)
        case "grayfilter":
            self.Gray(self.image)
        case "brightfilter":
            self.AdjustBrightness(self.image, percent: value)
        default:
            print("The selected filter do not exist.")
        }
        //}
    }
    
    func getAverages(_ image: RGBAImage) {
        
        var totalRed = 0
        var totalGreen = 0
        var totalBlue = 0
        
        for y in 0..<image.height {
            for x in 0..<image.width{
                
                let index = y * image.width + x
                var pixel = image.pixels[index]
                totalRed += Int(pixel.red)
                totalGreen += Int(pixel.green)
                totalBlue += Int(pixel.blue)
            }
        }
        
        let count = image.width * image.height
        self.redAvg = totalRed / count
        self.greenAvg = totalGreen / count
        self.blueAvg = totalBlue / count
        
    }
    
    func redFilter(_ image: RGBAImage, value: Float) {
        for y in 0..<self.image.height {
            for x in 0..<self.image.width{
                // Pixel index
                let index = y * self.image.width + x
                var pixel = self.image.pixels[index]
                
                let redDiff = Int(pixel.red) - redAvg
                
                if redDiff > 0 {
                    pixel.red = UInt8(max(0, min(255, redAvg + redDiff * Int(value))))
                    self.image.pixels[index] = pixel
                }
            }
        }
        
    }
    func Green(_ image: RGBAImage, value: Float) {
        for y in 0..<self.image.height {
            for x in 0..<self.image.width{
                // Pixel index
                let index = y * self.image.width + x
                var pixel = self.image.pixels[index]
                
                let greenDiff = Int(pixel.green) - greenAvg
                
                if greenDiff > 0 {
                    pixel.green = UInt8(max(0, min(255, greenAvg + greenDiff * Int(value))))
                    self.image.pixels[index] = pixel
                }
            }
        }
        
    }
    
    func Blue(_ image: RGBAImage, value: Float) {
        for y in 0..<self.image.height {
            for x in 0..<self.image.width{
                // Pixel index
                let index = y * self.image.width + x
                var pixel = self.image.pixels[index]
                
                let blueDiff = Int(pixel.blue) - blueAvg
                
                if blueDiff > 0 {
                    pixel.blue = UInt8(max(0, min(255, blueAvg + blueDiff * Int(value))))
                    self.image.pixels[index] = pixel
                }
            }
        }
        
    }
    
    
    
    func Gray(_ image: RGBAImage) {
        for y in 0..<self.image.height {
            for x in 0..<self.image.width{
                // Pixel index
                let index = y * self.image.width + x
                var pixel = self.image.pixels[index]
                
                let gray = 0.299 * Double(pixel.red) + 0.587 * Double(pixel.green) + 0.114 * Double(pixel.blue)
                let grayRounded = round(gray)
                
                // Update the pixels:
                pixel.red = UInt8(grayRounded)
                pixel.green = UInt8(grayRounded)
                pixel.blue = UInt8(grayRounded)
                
                
                self.image.pixels[index] = pixel
                
            }
        }
        
    }
    
    func AdjustBrightness(_ image: RGBAImage, percent: Float) {
        
        let adjust = Double(percent) / 100
        
        for y in 0..<self.image.height {
            for x in 0..<self.image.width{
                
                
                let index = y * self.image.width + x
                var pixel = self.image.pixels[index]
                
                let red = round(Double(pixel.red) * adjust)
                let blue = round(Double(pixel.blue) * adjust)
                let green = round(Double(pixel.green) * adjust)
                
                pixel.red = UInt8( max (0, min (255, red)))
                pixel.blue = UInt8( max (0, min (255, blue)))
                pixel.green = UInt8( max (0, min (255, green)))
                
                
                self.image.pixels[index] = pixel
                
            }
        }
        
    }
}
