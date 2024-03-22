//
//  UniPortalFormCell.swift
//  USW Connect
//
//  Created by ekincare on 11/03/24.
//

import UIKit

protocol UniPortalFormCellProtocol : AnyObject {
    func storeUserFields(data:String,indexRow:Int)
}

class UniPortalFormCell: UITableViewCell {
    
    @IBOutlet weak var dropdownIcon: UIImageView!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    weak var delegate: UniPortalFormCellProtocol?
    
    var cellType = FormTypes.none
    
    var indexRow = 0
        
    let areasOfInterest = [
        "Business and Management",
        "Engineering and Technology",
        "Arts and Humanities",
        "Sciences and Mathematics",
        "Social Sciences",
        "Education and Teaching",
        "Health Sciences",
        "Law and Legal Studies",
        "Creative Industries",
        "Computing and IT"
    ]
    
    override func prepareForReuse() {
        super.prepareForReuse()
        txtField.inputView = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        txtField.delegate = self
        mainView.backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        txtField.text   =   "\(sender.date.dateString("dd/MMM/yyyy"))"
    }
    
    func setData(data:UniPortalCellData) {
        titleLabel.setText(text: data.title.uppercased(), withKerning: 1.0)
        txtField.text = data.data
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 164/255, green: 176/255, blue: 204/255, alpha: 1.0),
            NSAttributedString.Key.font : UIFont(name: "Figtree-SemiBold", size: 14)!
        ]

        txtField.attributedPlaceholder = NSAttributedString(string: data.placeHolder, attributes:attributes)
        setUpViews()
    }
    
    func setUpViews() {
        addDoneButtonToToolBar()
        if cellType == .dateOfBirth {
            dropdownIcon.isHidden = false
            dropdownIcon.image = UIImage(named: "dobDropDown")
            var components = DateComponents()
            components.year = -16
            let minDate = Calendar.current.date(byAdding: components, to: Date())
            
            var components1 = DateComponents()
            components1.year = -160
            let maxDate = Calendar.current.date(byAdding: components1, to: Date())
            
            let datePickerView:UIDatePicker = UIDatePicker()
            datePickerView.datePickerMode = .date
            datePickerView.maximumDate    = minDate
            datePickerView.minimumDate    = maxDate
            if #available(iOS 13.4, *) {
                datePickerView.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
            txtField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControl.Event.valueChanged)
        }else if cellType == .areaOfIntrests {
            dropdownIcon.isHidden = false
            dropdownIcon.image = UIImage(named: "Triangle")
            let pickerView = UIPickerView()
            pickerView.delegate = self
            pickerView.dataSource = self
            txtField.inputView = pickerView
        }else {
            dropdownIcon.isHidden = true
        }
    }
    
    func addDoneButtonToToolBar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let additonalSpace = UIBarButtonItem(systemItem: .flexibleSpace, primaryAction: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonClicked))
        toolbar.setItems([additonalSpace,doneButton], animated: false)
        
        txtField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonClicked() {
        delegate?.storeUserFields(data: txtField.text ?? "",indexRow: indexRow)
        txtField.resignFirstResponder()
    }
    
}

extension UniPortalFormCell : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return areasOfInterest.count
    }
}

extension UniPortalFormCell : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return areasOfInterest[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedArea = areasOfInterest[row]
        txtField.text = selectedArea
    }
}

extension UniPortalFormCell : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,with: string)
            delegate?.storeUserFields(data: updatedText,indexRow: indexRow)
        }
        return true
    }
}
