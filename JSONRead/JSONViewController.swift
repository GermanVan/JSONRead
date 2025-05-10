import UIKit

class JSONViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var items: [Item] = []
    private let repository = Repository()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadData()
    }

    private func loadData() {
            repository.fetchItems { [weak self] (result: Result<[Item], Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let items):
                        self?.items = items
                        self?.tableView.reloadData()
                    case .failure:
                        let alert = UIAlertController(title: "Ошибка", message: "Не удалось загрузить данные.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "ОК", style: .default))
                        self?.present(alert, animated: true)
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

