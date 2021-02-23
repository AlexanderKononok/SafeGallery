//
//  UserImageStorageViewController.swift
//  SafeGallery
//
//  Created by Alexander Kononok on 12/20/20.
//

import UIKit

class UserImageStorageViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    var imagesArray: [UIImage] = Array()

    lazy var imagesPath = documentsPath.appendingPathComponent("Images")

    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileManager = FileManager.default
    private let pickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

//        deleteAllImages()
        collectionView.dataSource = self
        collectionView.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = self

//        print(documentsPath.path)

        if fileManager.fileExists(atPath: imagesPath.path) == false {
            do {
                try fileManager.createDirectory(atPath: imagesPath.path,
                                                withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        } else {
            if let images = try? fileManager.contentsOfDirectory(atPath: imagesPath.path) {
                for imageName in images {
                    print(imageName)
                    if let image = UIImage(contentsOfFile: "\(imagesPath.path)/\(imageName)") {
                        imagesArray.append(image)
                    }
                }
            }
        }

        addImageButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print("The count of images: \(imagesArray.count)")
    }

    func addImageButton() {
        let heightButton: CGFloat = 100
        let addImageButton = UIButton(frame: .zero)

        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        addImageButton.backgroundColor = .cyan
        addImageButton.setTitleColor(.black, for: .normal)
        addImageButton.setTitle("Add image", for: .normal)
        addImageButton.addTarget(self, action: #selector(self.addImageButtonPressed), for: .touchUpInside)

        self.view.addSubview(addImageButton)

        NSLayoutConstraint(item: addImageButton, attribute: .bottom, relatedBy: .equal,
                           toItem: self.view, attribute: .bottom, multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: addImageButton, attribute: .height, relatedBy: .equal,
                           toItem: nil, attribute: .notAnAttribute, multiplier: 1,
                           constant: heightButton).isActive = true
        NSLayoutConstraint(item: addImageButton, attribute: .leading, relatedBy: .equal,
                           toItem: self.view, attribute: .leading, multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: addImageButton, attribute: .trailing, relatedBy: .equal,
                           toItem: self.view, attribute: .trailing, multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal,
                           toItem: addImageButton, attribute: .top, multiplier: 1,
                           constant: 0).isActive = true

        self.view.layoutIfNeeded()
    }

    @objc func addImageButtonPressed(sender: UIButton!) {
        present(pickerController, animated: true)
    }

    func saveImage(image: UIImage) {
        let data = image.pngData()
        let imagePath = imagesPath.appendingPathComponent("\(Date().timeIntervalSince1970).png")
        fileManager.createFile(atPath: imagePath.path, contents: data, attributes: nil)
    }

    func deleteAllImages() {
        do {
            try fileManager.removeItem(atPath: imagesPath.path)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension UserImageStorageViewController: UIImagePickerControllerDelegate,
                                          UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let chosenImage = info[.originalImage] as? UIImage {
            imagesArray.append(chosenImage)
            saveImage(image: chosenImage)
            print(imagesArray.count)
        }

        picker.dismiss(animated: true) {
            self.collectionView.reloadData()
        }
    }
}

extension UserImageStorageViewController: UICollectionViewDataSource,
                                          UICollectionViewDelegate,
                                          UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: ImageCollectionViewCell.self), for: indexPath)
                as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.imageView.image = imagesArray[indexPath.item]

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 2) - 6, height: (view.frame.width / 2) - 6)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let imageViewController = imageStoryboard.instantiateViewController(
            identifier: String(describing: ImageViewController.self)) as? ImageViewController
        self.navigationController?.pushViewController(imageViewController ?? UIViewController(), animated: true)

        if let images = try? fileManager.contentsOfDirectory(atPath: imagesPath.path) {
            imageViewController?.selectedImageName = images[indexPath.item]
        }
    }
}
