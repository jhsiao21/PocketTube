import UIKit

import UIKit

class ATCTextField: UITextField {
    
    var textEdited: ((String) -> Void)? = nil

    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 5)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    func textValidation(completion: @escaping (String) -> Void) {
        textEdited = completion
        addTarget(self,
                  action: #selector(textFieldEditingChanged(_ :)), for: .editingChanged)
    }
    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        textEdited?(text)
    }
}
