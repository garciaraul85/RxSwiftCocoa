import UIKit
import RxSwift
import RxCocoa

class ChocolatesOfTheWorldViewController: UIViewController {
  @IBOutlet private var cartButton: UIBarButtonItem!
  @IBOutlet private var tableView: UITableView!
  // You’ll use to clean up any Observers you set up.
  private let disposeBag = DisposeBag()
  let europeanChocolates = Chocolate.ofEurope
}

//MARK: View Lifecycle
extension ChocolatesOfTheWorldViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Chocolate!!!"
    
    tableView.dataSource = self
    tableView.delegate = self
    setupCartObserver()
  }
}

//MARK: - Rx Setup
private extension ChocolatesOfTheWorldViewController {
  // This sets up a reactive Observer to update the cart automatically.
  func setupCartObserver() {
    //1: Grab the shopping cart’s chocolates variable as an Observable.
    ShoppingCart.sharedCart.chocolates.asObservable()
      .subscribe(onNext: { //2: Call subscribe(onNext:) on that Observable to discover changes to the Observable’s value. subscribe(onNext:) accepts a closure that executes every time the value changes. The incoming parameter to the closure is the new value of your Observable. You’ll keep getting these notifications until you either unsubscribe or dispose of your subscription. What you get back from this method is an Observer conforming to Disposable.
        [unowned self] chocolates in
        self.cartButton.title = "\(chocolates.count) \u{1f36b}"
      })
      .disposed(by: disposeBag) //3: Add the Observer from the previous step to your disposeBag. This disposes of your subscription upon deallocating the subscribing object.
  }
}

// MARK: - Table view data source
extension ChocolatesOfTheWorldViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return europeanChocolates.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ChocolateCell.Identifier, for: indexPath) as? ChocolateCell else {
      //Something went wrong with the identifier.
      return UITableViewCell()
    }
    
    let chocolate = europeanChocolates[indexPath.row]
    cell.configureWithChocolate(chocolate: chocolate)
    
    return cell
  }
}

// MARK: - Table view delegate
extension ChocolatesOfTheWorldViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let chocolate = europeanChocolates[indexPath.row]
    let newValue =  ShoppingCart.sharedCart.chocolates.value + [chocolate]
    ShoppingCart.sharedCart.chocolates.accept(newValue)
  }
}

// MARK: - SegueHandler
extension ChocolatesOfTheWorldViewController: SegueHandler {
  enum SegueIdentifier: String {
    case goToCart
  }
}
