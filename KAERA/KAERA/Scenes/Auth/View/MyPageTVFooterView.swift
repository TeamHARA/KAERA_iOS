//
//  MyPageTVFooterView.swift
//  KAERA
//
//  Created by 김담인 on 2023/10/17.
//

import UIKit

final class MyPageTVFooterView: UITableViewHeaderFooterView {
    
    let barView: UIView = {
        let view = UIView()
        view.backgroundColor = .kGray2
        return view
    }()
    
    
    // MARK: - Initialization
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setLayout()
        self.backgroundColor = .yellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        contentView.addSubview(barView)
        barView.translatesAutoresizingMaskIntoConstraints = false
        barView.heightAnchor.constraint(equalToConstant: 8).isActive = true
        barView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        barView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        barView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }

}

