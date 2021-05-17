//
//  ContactTableViewCell.swift
//  Good Friend
//
//  Created by Sarath Chandra Damineni on 2021-04-28.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    static let identifier = "ContactTableViewCell"
    
    private let imageContainer: UIView =
        {
           let view = UIView()
            view.clipsToBounds = true
            view.layer.cornerRadius = 8
            view.layer.masksToBounds = true
            return view
        }()
    private let contactImageView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let contactName: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(imageContainer)
        imageContainer.addSubview(contactImageView)
        contentView.addSubview(contactName)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size:CGFloat = contentView.frame.size.height - 12
        imageContainer.frame = CGRect(x: 20,y: 6, width: size, height: size)
        
        let imageSize:CGFloat = size/1.5
        contactImageView.frame = CGRect(x: (size - imageSize)/2, y:(size - imageSize)/2, width: imageSize, height: imageSize)
        
        contactName.frame = CGRect(x : 30 + imageContainer.frame.size.width,
            y: 0,
            width: contentView.frame.size.width - 30 - imageContainer.frame.size.width,
            height: contentView.frame.size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contactImageView.image = nil
        contactName.text = nil
        imageContainer.backgroundColor = nil
    }
    
    public func configure(with model: ContactOption)
    {
        contactName.text = model.name
        contactImageView.image = model.icon
        imageContainer.backgroundColor = model.iconBackgroundColor
    }
    
}
