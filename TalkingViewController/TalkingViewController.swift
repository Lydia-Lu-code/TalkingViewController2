import UIKit

class TalkingViewController: UIViewController {
    
    let messages = ["Hello!", "How are you?", "I'm good, thanks!thanks!thanks!thanks!thanks!thanks!", "What about you?What about you?What about you?What about you?What about you?What about you?", "I'm doing well too.", "How are you?", "I'm good, thanks!thanks!thanks!thanks!thanks!thanks!", "What about you?What about you?What about you?What about you?What about you?What about you?", "I'm doing well too.", "How are you?", "I'm good, thanks!thanks!thanks!thanks!thanks!thanks!", "What about you?What about you?What about you?What about you?What about你？", "I'm doing well too.", "I'm good, thanks!thanks!thanks!thanks!thanks!thanks!", "What about you?What about you?What about you?What about you?What about you?What about you?"]
    let images: [UIImage?] = [UIImage(named: "image1"), UIImage(named: "image2"), UIImage(named: "image3"), UIImage(named: "image4"), UIImage(named: "image5"), UIImage(named: "image1"), UIImage(named: "image2"), UIImage(named: "image3"), UIImage(named: "image4"), UIImage(named: "image5"), UIImage(named: "image1"), UIImage(named: "image2"), UIImage(named: "image3"), UIImage(named: "image4"), UIImage(named: "image5")]
    let isIncomingMessages = [true, true, true, false, true, true, true, true, false, true, true, true, true, false, true] // 模擬A和B的對話
    
    var tableView: UITableView!
    var name = "Alice"
    var cellCache: [IndexPath: UITableViewCell] = [:] // Cell缓存
    
    // 創建並配置 CustomView
    let inputButtonView: InputButtonView = {
        let view = InputButtonView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // 设置 tableView 的约束，对齐 safe area
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TalkerCell.self, forCellReuseIdentifier: "ChatCell")
        tableView.separatorStyle = .none // 移除 cell 分隔线
        
        
        view.addSubview(inputButtonView)
        
        reloadTableViewDataWithoutChangingCellHeights()
        
        NSLayoutConstraint.activate([
            inputButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            inputButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            inputButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            inputButtonView.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        // 添加手勢識別器
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // 註冊鍵盤顯示和隱藏的通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        
        UIView.animate(withDuration: 0.3) {
            // 將 inputButtonView 向上移動，使其不被鍵盤遮擋
            self.inputButtonView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            // 恢復 inputButtonView 的原始位置
            self.inputButtonView.transform = .identity
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func reloadTableViewDataWithoutChangingCellHeights() {
        // 保持当前的 rowHeight 设置
        let currentRowHeight = tableView.rowHeight
        let currentEstimatedRowHeight = tableView.estimatedRowHeight
        
        // 设置 tableView 的数据源和委托为 nil，避免在 reloadData() 时触发自动计算高度
        tableView.dataSource = nil
        tableView.delegate = nil
        
        // 执行 reloadData() 操作
        tableView.reloadData()
        
        // 恢复原来的 rowHeight 设置
        tableView.rowHeight = currentRowHeight
        tableView.estimatedRowHeight = currentEstimatedRowHeight
        
        // 重新设置数据源和委托
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension TalkingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cachedCell = cellCache[indexPath] {
            return cachedCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! TalkerCell
        let message = messages[indexPath.row]
        let image = images[indexPath.row]
        let isIncoming = isIncomingMessages[indexPath.row]
        cell.configure(with: message, image: image, isIncoming: isIncoming, name: name)
        
        // 缓存 cell
        cellCache[indexPath] = cell
        
        // 打印消息文字
        print("Cell at row \(indexPath.row) configured with message: \(message)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear // 设置背景色为透明
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = name
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        // 创建一个包装视图，以确保 headerView 能够对齐 safe area
        let wrapperView = UIView()
        wrapperView.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: wrapperView.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor)
        ])
        
        return wrapperView
    }
}


