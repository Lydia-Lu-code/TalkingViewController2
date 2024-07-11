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
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func keyboardWillShow(height: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.inputButtonView.transform = CGAffineTransform(translationX: 0, y: -height)
        }
    }
    
    func keyboardWillHide() {
        UIView.animate(withDuration: 0.3) {
            self.inputButtonView.transform = .identity
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
