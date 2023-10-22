//
//  MyPageTVHeaderView.swift
//  KAERA
//
//  Created by 김담인 on 2023/10/17.
//

import UIKit

final class MyPageTVHeaderView: UITableViewHeaderFooterView {

    private let headerTitle: UILabel = {
        let label = UILabel()
        label.font = .kH3B18
        label.textColor = .kWhite
        return label
    }()
    
    // MARK: - Initialization
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(title: String) {
        self.headerTitle.text = title
    }
    
    private func setLayout() {
        contentView.addSubview(headerTitle)
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        headerTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15).isActive = true
        headerTitle.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 42.adjustedH).isActive = true
        headerTitle.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -24.adjustedH).isActive = true
    }

}
