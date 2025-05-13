import UIKit

class JSONViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadButton: UIButton!
    
    private var items: [Item] = []
    private let repository = Repository()
    private var isLoading = false
    
    private lazy var errorAlert: UIAlertController = {
        let alert = UIAlertController(title: "Ошибка", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        return alert
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadButton.addTarget(self, action: #selector(loadButtonTapped), for: .touchUpInside)
    }
    
    @objc private func loadButtonTapped() {
        guard !isLoading else { return }
        isLoading = true
        loadButton.isEnabled = false
        repository.fetchItems { [weak self] (result: Result<[Item], DataError>) in
            DispatchQueue.main.async {
                defer {
                    self?.isLoading = false
                    self?.loadButton.isEnabled = true
                }
                switch result {
                case .success(let items):
                    self?.items = items
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.errorAlert.message = error.localizedDescription
                    self?.present(self!.errorAlert, animated: true)
                }
            }
        }
    }
}

extension JSONViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.login
        return cell
    }
}


