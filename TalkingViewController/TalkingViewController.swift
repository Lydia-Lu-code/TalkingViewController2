import UIKit

class TalkingViewController: UIViewController, InputButtonViewDelegate {

    
    let messages = [
        "昨天晚上你聽到那個聲音了嗎？",
        "聽到了！太可怕了，好像是有人在走廊走來走去。",
        "我也聽到了，我以為是幻覺。",
        "不，只要過了午夜，那聲音就開始了。",
        "你有沒有想過會不會是…學校的那個傳說？",
        "你是說那個消失的學生？",
        "對啊，有人說她一直在找不到她的書包。",
        "可是為什麼半夜會出現聲音？",
        "也許她還在找，想回家卻回不去。",
        "聽說她每晚都在我們宿舍徘徊。",
        "太恐怖了！我們該怎麼辦？",
        "或許我們應該去找出那個書包，讓她安息。",
        "是啊，可是我們總不能一直這樣害怕。",
        "好吧，今晚我們一起去看看。",
        "嗯，我們一起面對。"
    ]

    let images: [UIImage?] = Array(repeating: UIImage(named: "image2.png"), count: 15)

    let isIncomingMessages = [
        false,
        true,
        false,
        true,
        false,
        true,
        false,
        true,
        false,
        false,
        true,
        false,
        true,
        false,
        true
    ]

    var tableView: UITableView!
    var name = "Alice"
    var cellCache: [IndexPath: UITableViewCell] = [:]
    var keyboardHeight: CGFloat = 0.0
    var initialContentInset: UIEdgeInsets = .zero

    let topStackView: TopStackView = {
        let view = TopStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 45).isActive = true
        return view
    }()

    let inputButtonView: InputButtonView = {
        let view = InputButtonView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 45).isActive = true
        return view
    }()

    var tableViewBottomConstraint: NSLayoutConstraint!
    
    var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TalkerCell.self, forCellReuseIdentifier: "ChatCell")
        tableView.separatorStyle = .none

        stackView = UIStackView(arrangedSubviews: [topStackView, tableView, inputButtonView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        // 設置 inputButtonView 的 delegate
        inputButtonView.delegate = self
        inputButtonView.textField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)

        initialContentInset = tableView.contentInset

        // 計算並設置 tableView 的 contentOffset
        scrollToBottom()
        
        // Add observers for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func updateTableViewInsets() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: initialContentInset.bottom , right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
    }

    func scrollToBottom() {
        DispatchQueue.main.async {
            let lastIndexPath = IndexPath(row: self.messages.count - 1, section: 0)
            let rect = self.tableView.rectForRow(at: lastIndexPath)
            let offset = rect.maxY - self.tableView.bounds.height + self.tableView.contentInset.bottom
            self.tableView.contentOffset = CGPoint(x: 0, y: offset)
        }
    }
    
    @objc func textFieldDidBeginEditing() {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShowNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            print("TVC Keyboard will show height Notification: \(keyboardHeight)")

            UIView.animate(withDuration: 0.3) {
                self.tableView.contentInset.bottom = keyboardHeight
                self.scrollToBottom()
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHideNotification(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.tableView.contentInset.bottom = self.initialContentInset.bottom
            self.scrollToBottom()
            self.view.layoutIfNeeded()
        }
        
    }



    func keyboardWillShow(height: CGFloat) {
        print("TVC Keyboard will show height: \(height)")
        UIView.animate(withDuration: 0.3) {
            self.inputButtonView.transform = CGAffineTransform(translationX: 0, y: -height)
            self.updateTableViewInsets()
            self.view.layoutIfNeeded()
        }

    }

    func keyboardWillHide() {
        UIView.animate(withDuration: 0.3) {
            self.inputButtonView.transform = .identity
            self.tableView.contentInset = self.initialContentInset
            self.updateTableViewInsets()
            self.view.layoutIfNeeded()
        }
    }

}

extension TalkingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = cellCache[indexPath] else {
            let newCell = TalkerCell(style: .default, reuseIdentifier: "ChatCell")
            newCell.configure(with: messages[indexPath.row],
                              image: images[indexPath.row],
                              isIncoming: isIncomingMessages[indexPath.row],
                              name: name)
            cellCache[indexPath] = newCell
            return newCell
        }
        return cell
    }
    
}
