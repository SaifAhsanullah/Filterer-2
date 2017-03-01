

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var filteredImage: UIImage?
    var originalImage: UIImage?
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    @IBOutlet var sliderBar: UIView!
    
    @IBOutlet var filterButton: UIButton!
    @IBOutlet weak var compareButton: UIButton!
    
    @IBOutlet weak var labelOriginalImage: UILabel!
    
    //filter buttons
    @IBOutlet weak var noFilterButton: UIButton!
    @IBOutlet weak var redFilter: UIButton!
    @IBOutlet weak var greenFilterButton: UIButton!
    @IBOutlet weak var blueFilterButton: UIButton!
    @IBOutlet weak var grayFilter: UIButton!
    @IBOutlet weak var brightFilterButton: UIButton!
    
    @IBOutlet weak var slider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        secondaryMenu.backgroundColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        
        sliderBar.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.7)
        sliderBar.translatesAutoresizingMaskIntoConstraints = false
        
        //save the first image pre-loaded
        originalImage = imageView.image
        
        
    }
    
    // MARK: Share
    @IBAction func onShare(_ sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", filteredImage!], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(_ sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .photoLibrary
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            originalImage = image
            filterButton.isSelected = false
            redFilter.isSelected = false
            greenFilterButton.isSelected = false
            blueFilterButton.isSelected = false
            grayFilter.isSelected = false
            brightFilterButton.isSelected = false
            hideSecondaryMenu()
            hideSliderMenu()
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(_ sender: UIButton) {
        if (sender.isSelected) {
            hideSecondaryMenu()
            sender.isSelected = false
        } else {
            showSecondaryMenu()
            sender.isSelected = true
        }
    }
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraint(equalToConstant: 44)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }
    
    func hideSecondaryMenu() {
        UIView.animate(withDuration: 0.4, animations: {
            self.secondaryMenu.alpha = 0
        }) { completed in
            if completed == true {
                self.secondaryMenu.removeFromSuperview()
            }
        }
    }
    
    func showSliderMenu() {
        view.addSubview(sliderBar)
        
        let bottomConstraint = sliderBar.bottomAnchor.constraint(equalTo: secondaryMenu.topAnchor)
        let leftConstraint = sliderBar.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = sliderBar.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let heightConstraint = sliderBar.heightAnchor.constraint(equalToConstant: 44)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.sliderBar.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.sliderBar.alpha = 1.0
        }
        
    }
    
    func hideSliderMenu() {
        UIView.animate(withDuration: 0.4, animations: {
            self.sliderBar.alpha = 0
        }) { completed in
            if completed == true {
                self.sliderBar.removeFromSuperview()
            }
        }
    }
    
    @IBAction func sliderValue(_ sender: UISlider) {
        
        switch sender.tag {
        case 1 :
            RedFilter(redFilter)
        case 2 :
            greenFilter(greenFilterButton)
        case 3 :
            blueFilter(blueFilterButton)
        case 5 :
            brightFilter(brightFilterButton)
        default:
            print("nothing")
        }
        
        compareButton.isSelected = false
        
    }
    
    
    @IBAction func compare(_ sender: UIButton) {
        if (sender.isSelected) {
            showFilteredImage()
            sender.isSelected = false
            
        } else {
            showOriginalImage()
            sender.isSelected = true
        }
        
        
    }
    
    @IBAction func removeFilters(_ sender: UIButton) {
        
        redFilter.isSelected = false
        greenFilterButton.isSelected = false
        blueFilterButton.isSelected = false
        grayFilter.isSelected = false
        
        filteredImage = originalImage
        
        UIView.transition(with: self.imageView,
                          duration:0.6,
                          options: .transitionCrossDissolve,
                          animations: { self.imageView.image = self.filteredImage },
                          completion: nil)
        //remove label content
        labelOriginalImage.text = ""
        labelOriginalImage.backgroundColor = nil
        
        compareButton.isEnabled = false
        
        hideSliderMenu()
        
    }
    
    @IBAction func RedFilter(_ sender: UIButton) {
        
        
        if (sender.isSelected == false) {
            
            showSliderMenu()
            
            //config slider according filter type
            slider.minimumValue = 1.0
            slider.maximumValue = 10.0
            slider.value = 5.0
            slider.tag = 1
            
            //unselect other buttons
            greenFilterButton.isSelected = false
            blueFilterButton.isSelected = false
            grayFilter.isSelected = false
            brightFilterButton.isSelected = false
            compareButton.isSelected = false
            
            let filter = ImageFilter(image: self.originalImage!)
            
            
            filter.applyFilter(["redfilter"], value: slider.value)
            
            
            
            
            filteredImage = filter.toUIImage()
            
            showFilteredImage()
            
            sender.isSelected = true
            
            //activate compare button
            compareButton.isEnabled = true
            
            
        }else{ //runs when use slide bar
            let filter = ImageFilter(image: self.originalImage!)
            
            filter.applyFilter(["redfilter"], value: slider.value)
            
            filteredImage = filter.toUIImage()
            
            showFilteredImage()
            
        }
        
        
    }
    
    @IBAction func greenFilter(_ sender: UIButton) {
        
        if (sender.isSelected == false) {
            
            showSliderMenu()
            
            //config slider according filter type
            slider.minimumValue = 1.0
            slider.maximumValue = 10.0
            slider.value = 5.0
            slider.tag = 2
            
            redFilter.isSelected = false
            blueFilterButton.isSelected = false
            grayFilter.isSelected = false
            brightFilterButton.isSelected = false
            compareButton.isSelected = false
            
            let filter = ImageFilter(image: self.originalImage!)
            
            filter.applyFilter(["greenfilter"], value: slider.value)
            
            filteredImage = filter.toUIImage()
            
            showFilteredImage()
            
            sender.isSelected = true
            
            //activate compare button
            compareButton.isEnabled = true
            
        }else{ //runs when use slide bar
            
            let filter = ImageFilter(image: self.originalImage!)
            
            filter.applyFilter(["greenfilter"], value: slider.value)
            
            filteredImage = filter.toUIImage()
            
            showFilteredImage()
            
        }
        
        
    }
    @IBAction func blueFilter(_ sender: UIButton) {
        
        if (sender.isSelected == false) {
            
            showSliderMenu()
            
            //config slider according filter type
            slider.minimumValue = 1.0
            slider.maximumValue = 10.0
            slider.value = 5.0
            slider.tag = 3
            
            redFilter.isSelected = false
            greenFilterButton.isSelected = false
            grayFilter.isSelected = false
            brightFilterButton.isSelected = false
            compareButton.isSelected = false
            
            let filter = ImageFilter(image: self.originalImage!)
            
            filter.applyFilter(["bluefilter"], value: slider.value)
            
            filteredImage = filter.toUIImage()
            
            showFilteredImage()
            
            sender.isSelected = true
            
            //activate compare button
            compareButton.isEnabled = true
        }else{ //runs when use slide bar
            
            let filter = ImageFilter(image: self.originalImage!)
            
            filter.applyFilter(["bluefilter"], value: slider.value)
            
            filteredImage = filter.toUIImage()
            
            showFilteredImage()
            
        }
    }
    
    
    @IBAction func grayFilter(_ sender: UIButton) {
        if (sender.isSelected == false) {
            
            //this filter don't need slider option.
            hideSliderMenu()
            
            redFilter.isSelected = false
            greenFilterButton.isSelected = false
            blueFilterButton.isSelected = false
            brightFilterButton.isSelected = false
            compareButton.isSelected = false
            
            let filter = ImageFilter(image: self.originalImage!)
            
            filter.applyFilter(["grayfilter"], value: slider.value)
            
            filteredImage = filter.toUIImage()
            
            showFilteredImage()
            
            sender.isSelected = true
            
            //activate compare button
            compareButton.isEnabled = true
        }
        
    }
    
    @IBAction func brightFilter(_ sender: UIButton) {
        
        if (sender.isSelected == false) {
            
            showSliderMenu()
            
            //config slider according filter type
            slider.minimumValue = 1.0
            slider.maximumValue = 300.0
            slider.value = 150.0
            slider.tag = 5
            
            redFilter.isSelected = false
            greenFilterButton.isSelected = false
            blueFilterButton.isSelected = false
            grayFilter.isSelected = false
            compareButton.isSelected = false
            
            let filter = ImageFilter(image: self.originalImage!)
            
            filter.applyFilter(["brightfilter"], value: slider.value)
            
            filteredImage = filter.toUIImage()
            
            showFilteredImage()
            
            sender.isSelected = true
            
            //activate compare button
            compareButton.isEnabled = true
            
            
        }else{ //runs when use slide bar
            
            let filter = ImageFilter(image: self.originalImage!)
            
            filter.applyFilter(["brightfilter"], value: slider.value)
            
            filteredImage = filter.toUIImage()
            
            showFilteredImage()
            
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        if touch.view == imageView {
            
            showOriginalImage()
            
        }
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        if touch.view == imageView {
            
            showFilteredImage()
            
            
        }
    }
    
    
    //transitions between images in imageView
    func showOriginalImage(){
        UIView.transition(with: self.imageView,
                          duration:0.6,
                          options: .transitionCrossDissolve,
                          animations: { self.imageView.image = self.originalImage },
                          completion: nil)
        
        //show label for original image
        labelOriginalImage.text = "Original Image"
        labelOriginalImage.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.5)
        
        compareButton.isSelected = true
        
    }
    
    func showFilteredImage(){
        UIView.transition(with: self.imageView,
                          duration:0.6,
                          options: .transitionCrossDissolve,
                          animations: { self.imageView.image = self.filteredImage },
                          completion: nil)
        //remove label content
        labelOriginalImage.text = ""
        labelOriginalImage.backgroundColor = nil
        
        compareButton.isSelected = false
    }
    
    
}

