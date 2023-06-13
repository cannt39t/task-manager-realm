//
//  TaskTableViewCell.swift
//  RealmSwiftTest
//
//  Created by Илья Казначеев on 13.06.2023.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    static let identifier = "TaskTableViewCell"
    public var task: Task!
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupLayout() {
        contentView.addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 9),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 9),
            titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            titleTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }
    
    public func setupCellWith(task: Task) {
        self.task = task
        titleTextField.text = task.title
    }
}
