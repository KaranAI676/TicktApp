//
//  JobTypeCell.swift
//  Tickt
//
//  Created by Admin on 25/03/21.
//

import UIKit
import SDWebImage

protocol SelectJobDelegate: AnyObject {
    func didJobSelected(index: Int)
}

class JobTypeCell: UITableViewCell {

    var jobs: [JobType]?
    var selectedIndex = -1
    weak var delegate: SelectJobDelegate?
    
    @IBOutlet weak var jobCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    private func initialSetup() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        jobCollectionView.setCollectionViewLayout(layout, animated: false)
        jobCollectionView.register(UINib(nibName: JobCell.defaultReuseIdentifier, bundle: .main), forCellWithReuseIdentifier: JobCell.defaultReuseIdentifier)
        jobCollectionView.delegate = self
        jobCollectionView.dataSource = self
    }
}

extension JobTypeCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobCell.defaultReuseIdentifier, for: indexPath) as? JobCell else {
            return UICollectionViewCell()
        }

        cell.jobTypeLabel.text = jobs![indexPath.row].name        
        cell.jobImageView.sd_setImage(with: URL(string:(jobs![indexPath.row].image)), placeholderImage: nil, options: .highPriority) { (image, error, _ , _) in
            let resizedImage = image?.resized(toWidth: kScreenWidth * 0.5, isOpaque: false)
            cell.jobImageView.image = resizedImage
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        delegate?.didJobSelected(index: indexPath.item)
        collectionView.reloadItems(at: [indexPath])
    }
}
  
extension JobTypeCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = textSize(text: jobs![indexPath.row].name, font: UIFont.kAppDefaultFontRegular(ofSize: 12.0), collectionView: jobCollectionView)
        size.height += 8.0
        size.width += 16
        return size
    }
}

extension JobTypeCell {
    func textSize(text: String, font: UIFont, collectionView: UICollectionView) -> CGSize {
        var frame = collectionView.bounds
        frame.size.height = 300
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.font = font
        var size = label.sizeThatFits(frame.size)
        size.width = max(40, size.width + 30)
        size.height = 40
        return size
    }
}
