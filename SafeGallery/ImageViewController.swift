//
//  ImageViewController.swift
//  SafeGallery
//
//  Created by Alexander Kononok on 12/23/20.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    var selectedImageName: String = ""

    lazy var imagesPath = documentsPath.appendingPathComponent("Images")

    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileManager = FileManager.default

    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage(contentsOfFile: "\(imagesPath.path)/\(selectedImageName)")
        self.imageView.image = image
    }

    @IBAction func deleteImageButtonPressed(_ sender: Any) {
        print("Image \"\(selectedImageName)\" was deleted")
    }
}
