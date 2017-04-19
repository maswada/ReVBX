//
//  EditImageViewController.swift
//  ReVBX
//
//  Created by 和田 昌紘 on 2017/04/18.
//  Copyright © 2017年 mediba inc. All rights reserved.
//

import UIKit

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
            self.imageView.image = image
            self.ciimage = CIImage(image: image)
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

        let filter6 = CIFilter(name: "CIToneCurve")
        self.filters.append([nameKey: "Curve", filterKey: filter6 as Any])
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
        self.dismiss(animated: true, completion: nil)
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let info = self.filters[indexPath.row]
        if let filter = info[filterKey] as? CIFilter {
            filter.setValue(self.ciimage, forKey: "inputImage")
        
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
