//
//  TaskTableViewCell.swift
//  TodoListApp
//
//  Created by Workwise 1 on 04/08/2025.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var priorityImg1: UIImageView!
    @IBOutlet weak var priorityImg2: UIImageView!
    @IBOutlet weak var priorityImg3: UIImageView!
    
    var onStatusChange: (() -> Void)?  // Closure for callback to controller

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
