//
//  TalkersCell.swift
//  TalkersViewController
//
//  Created by Lydia Lu on 2024/7/9.
//

import UIKit

class TalkerCell: UITableViewCell {

    let profileImageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        img.layer.cornerRadius = 25
        img.clipsToBounds = true
        return img
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let bubbleBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.textColor = .lightGray
        return label
    }()
    
    
    var isIncoming: Bool = true {
        didSet {
            updateConstraintsForDirection()
            updateColorsForDirection()
        }
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(bubbleBackgroundView)
        bubbleBackgroundView.addSubview(messageLabel)
        
        print("Subviews added")
        for subview in contentView.subviews {
            print("Subview: \(subview)")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with message: String, image: UIImage?, isIncoming: Bool, name: String? = nil) {
        if messageLabel.text != message {
            messageLabel.text = message
        }
        if profileImageView.image != image {
            profileImageView.image = image
        }
        self.isIncoming = isIncoming

        if isIncoming {
            nameLabel.text = name ?? "Unknown"
        } else {
            nameLabel.text = nil
        }

        print("Configured: nameLabel.text = \(String(describing: nameLabel.text))")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
        profileImageView.image = nil
        nameLabel.text = nil
    }
    
    private func updateConstraintsForDirection() {
        NSLayoutConstraint.deactivate(profileImageView.constraints)
        NSLayoutConstraint.deactivate(bubbleBackgroundView.constraints)
        NSLayoutConstraint.deactivate(messageLabel.constraints)
        NSLayoutConstraint.deactivate(nameLabel.constraints)
        
        if isIncoming {
            NSLayoutConstraint.activate([
                profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                profileImageView.widthAnchor.constraint(equalToConstant: 50),
                profileImageView.heightAnchor.constraint(equalToConstant: 50),
                
                nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
                nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                
                bubbleBackgroundView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
                bubbleBackgroundView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -50),
                bubbleBackgroundView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
                bubbleBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                
                messageLabel.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: 8),
                messageLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -8),
                messageLabel.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: 8),
                messageLabel.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -8),
                
            ])
        } else {
            NSLayoutConstraint.activate([
                bubbleBackgroundView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 100),
                bubbleBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                bubbleBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                bubbleBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                
                messageLabel.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: 8),
                messageLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -8),
                messageLabel.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: 8),
                messageLabel.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -8),
            ])
        }
//        print("Cell height: \(self.frame.height)")
        print("Constraints updated")
    }
    
    private func updateColorsForDirection() {
        if isIncoming {
            // left
            profileImageView.backgroundColor = .yellow
            bubbleBackgroundView.backgroundColor = .blue
        } else {
            bubbleBackgroundView.backgroundColor = .green
        }
    }
}
