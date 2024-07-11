
import UIKit

class TalkingViewController: UIViewController, InputButtonViewDelegate {

    // MARK: - 屬性宣告
    
    let messages = [
        "messages01", "messages02messages02messages02", "messages03",
        "messages04messages04messages04messages04messages04", "messages05",
        "messages06", "messages07", "messages08messages08messages08messages08messages08",
        "messages09", "messages10", "messages11messages11messages11", "messages12",
        "messages13", "messages14messages14messages14messages14messages14", "messages15"
    ]

    let images: [UIImage?] = Array(repeating: UIImage(named: "image2.png"), count: 15)

    let isIncomingMessages = [
        true, true, true, false, true, true, true, true, false, true,
        true, true, true, true, false, true
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

        let stackView = UIStackView(arrangedSubviews: [topStackView, tableView, inputButtonView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        // 設置 inputButtonView 的 delegate
        inputButtonView.delegate = self

        // 初始化 tableView 的 contentInset
        initialContentInset = tableView.contentInset
    }


    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - 鍵盤通知處理
    
//    @objc func keyboardWillShow(_ notification: Notification) {
//        guard let userInfo = notification.userInfo,
//              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
//            return
//        }
//        keyboardHeight = keyboardFrame.height
//        
//        print("TVC keyboardHeight == \(keyboardHeight)")
//
//
//        UIView.animate(withDuration: 0.3) {
//            // 將 inputButtonView 上移以與鍵盤頂部對齊
//            self.inputButtonView.transform = CGAffineTransform(translationX: 0, y: -self.keyboardHeight)
//            
//            // 調整 tableView 的 contentInset 以與 inputButtonView 的頂部對齊
//            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.keyboardHeight, right: 0)
//            
//            // 調整 stackView 的底部約束，使其與 view 的 safeAreaLayoutGuide 底部對齊
//            self.inputButtonView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//
//            self.view.layoutIfNeeded()
//        }
//    }
//
//
//    @objc func keyboardWillHide(_ notification: Notification) {
//        UIView.animate(withDuration: 0.3) {
//            // 還原 inputButtonView 和 tableView 的位置
//            self.inputButtonView.transform = .identity
//            self.tableView.contentInset = self.initialContentInset
//        }
//    }

    // MARK: - InputButtonViewDelegate

    func keyboardWillShow(height: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            // 將 inputButtonView 上移以與指定高度的鍵盤頂部對齊
            self.inputButtonView.transform = CGAffineTransform(translationX: 0, y: -height+36)

            // 調整 tableView 的 contentInset 以與 inputButtonView 的頂部對齊
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
        }
    }

    func keyboardWillHide() {
        UIView.animate(withDuration: 0.3) {
            // 還原 inputButtonView 和 tableView 的位置
            self.inputButtonView.transform = .identity
            self.tableView.contentInset = self.initialContentInset
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


