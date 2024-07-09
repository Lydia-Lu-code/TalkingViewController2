import UIKit

class InputButtonView: UIView {
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup Method
    private func setupView() {
        // 設置 UIView 的元件
        let button1 = UIButton()
        let button2 = UIButton()
        let button3 = UIButton()
        let textField = UITextField()
        let button4 = UIButton()
        
        button1.backgroundColor = .systemBlue
        button2.backgroundColor = .systemBlue
        button3.backgroundColor = .systemBlue
        button4.backgroundColor = .systemBlue
        
        button1.translatesAutoresizingMaskIntoConstraints = false
        button2.translatesAutoresizingMaskIntoConstraints = false
        button3.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        button4.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(button1)
        addSubview(button2)
        addSubview(button3)
        addSubview(textField)
        addSubview(button4)
        
        // 設置 Stack View
        let stackView = UIStackView(arrangedSubviews: [button1, button2, button3, textField, button4])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        // 設置 Auto Layout Constraints
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor),
            
            button1.heightAnchor.constraint(equalTo: heightAnchor),
            button1.widthAnchor.constraint(equalTo: button1.heightAnchor),
            
            button2.heightAnchor.constraint(equalTo: button1.heightAnchor),
            button2.widthAnchor.constraint(equalTo: button1.heightAnchor),
            
            button3.heightAnchor.constraint(equalTo: button1.heightAnchor),
            button3.widthAnchor.constraint(equalTo: button1.heightAnchor),
            
            textField.heightAnchor.constraint(equalToConstant: 30),
            
            button4.heightAnchor.constraint(equalTo: button1.heightAnchor),
            button4.widthAnchor.constraint(equalTo: button1.heightAnchor),
        ])
        
        // 調整 UITextField 的優先級
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}




