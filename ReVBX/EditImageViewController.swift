//
//  EditImageViewController.swift
//  ReVBX
//
//  Created by 和田 昌紘 on 2017/04/18.
//  Copyright © 2017年 mediba inc. All rights reserved.
//

import UIKit

extension UIImageOrientation  {
    func degrees() -> CGFloat {
        switch self {
        case .up:
            return 0
        case .down:
            return CGFloat(M_PI)
        case .left:
            return CGFloat(M_PI_2)
        case .right:
            return CGFloat(-M_PI_2)
        default:
            return 0.0
        }
    }
}

class EditImageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var image: UIImage?
    var ciimage: CIImage?
    var filters: Array<Dictionary<String, Any>> = []
    
    let nameKey = "name"
    let filterKey = "filter"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = self.image {
            self.image = image
            
            let filterImage = self.rotatedImage(targetImage: UIImage(named: "overlay")!, toMatchImage: image)
            let filterCiimage = CIImage(image: filterImage)
            
            let composeFilter = CIFilter(name: "CISourceAtopCompositing")
            composeFilter?.setValue(filterCiimage, forKey: kCIInputImageKey)
            composeFilter?.setValue(CIImage(image: image), forKey: kCIInputBackgroundImageKey)

            self.ciimage = composeFilter?.outputImage
            let context = CIContext(options: nil)
            let imageRef = context.createCGImage(self.ciimage!, from: (self.ciimage?.extent)!)
            let outputImage = UIImage(cgImage: imageRef!, scale: image.scale, orientation: image.imageOrientation)
            self.imageView.image = outputImage
        }
        
        let filter0 = CIFilter(name: "CIVignette")
        filter0?.setValue(2.0, forKey: "inputIntensity")
        self.filters.append([nameKey: "Vignette", filterKey: filter0 as Any])
        
        let filter1 = CIFilter(name: "CICategoryBlur")
        filter1?.setValue(10.0, forKey: "inputRadius")
        self.filters.append([nameKey: "Blur", filterKey: filter1 as Any])

        let filter2 = CIFilter(name: "CIPhotoEffectMono")
        self.filters.append([nameKey: "Mono", filterKey: filter2 as Any])
        
        let filter3 = CIFilter(name: "CIPhotoEffectInstant")
        self.filters.append([nameKey: "Instant", filterKey: filter3 as Any])

        let filter4 = CIFilter(name: "CIPhotoEffectFade")
        self.filters.append([nameKey: "Fade", filterKey: filter4 as Any])

        let filter5 = CIFilter(name: "CIPhotoEffectProcess")
        self.filters.append([nameKey: "Process", filterKey: filter5 as Any])

        let filter6 = CIFilter(name: "CISepiaTone")
        self.filters.append([nameKey: "Sepia", filterKey: filter6 as Any])
    }
    
    func rotatedImage(targetImage: UIImage, toMatchImage bgImage: UIImage) -> UIImage {
        
        let screenSize = UIScreen.main.bounds.size
        NSLog("screen bounds  :\(UIScreen.main.bounds)")
        NSLog("filter size    :\(targetImage.size)")
        
        
        let bgImageSize = self.rotatedSize(originalImage: bgImage)
        NSLog("bgImageSize    :\(bgImageSize)")
        UIGraphicsBeginImageContext(bgImageSize)
        
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        bitmap.translateBy(x: bgImageSize.width / 2, y: bgImageSize.height / 2)
        bitmap.rotate(by: self.image!.imageOrientation.degrees())
        bitmap.scaleBy(x: 1.0, y: -1.0)
        
        // only full square image
        let fixedfilterSize = CGSize(width: screenSize.width, height: screenSize.width)
        NSLog("fixedfilterSize:\(fixedfilterSize)")

        let ratio = bgImageSize.height/fixedfilterSize.height
        NSLog("bgImgscale      :\(bgImage.scale)")
        NSLog("ratio           :\(ratio)")
        let origin = CGPoint(x: -fixedfilterSize.width*ratio/2, y: -fixedfilterSize.height*ratio/2)
        
        let rect = CGRect(origin: origin, size: CGSize(width: fixedfilterSize.width*ratio, height: fixedfilterSize.height*ratio))
        NSLog("filterRect      :\(rect)")
        bitmap.draw(targetImage.cgImage!, in: rect)
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func rotatedSize(originalImage: UIImage) -> CGSize {
        switch originalImage.imageOrientation {
        case .right, .left:
            return CGSize(width: originalImage.size.height, height: originalImage.size.width)
        default:
            return originalImage.size
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func closeButtonAction(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(self.imageView.image!, nil, nil, nil)
        self.dismiss(animated: true, completion: nil)
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let info = self.filters[indexPath.row]
        if let filter = info[filterKey] as? CIFilter {
            filter.setValue(self.ciimage, forKey: kCIInputImageKey)
        
            let context = CIContext(options: nil)
            let imageRef = context.createCGImage((filter.outputImage)!, from: (filter.outputImage?.extent)!)
            let outputImage = UIImage(cgImage: imageRef!, scale: 1.0, orientation: (self.image?.imageOrientation)!)
            self.imageView.image = outputImage
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kFilterCell", for: indexPath) as! FilterCollectionViewCell
        cell.backgroundColor = UIColor.lightGray
        let info = self.filters[indexPath.row]
        let filterName = info[nameKey] as! String
        cell.title.text = filterName
        
        return cell
    }

    
}
