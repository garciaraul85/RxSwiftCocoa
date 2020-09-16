import Foundation
import RxSwift
import RxCocoa

class ShoppingCart {
  static let sharedCart = ShoppingCart()
// Essentially, rather than setting chocolates to a Swift array of Chocolate objects, you’ve now defined it as a RxSwift BehaviorRelay that has a type of a Swift array of Chocolate objects.
// BehaviorRelay has a property called value. This stores your array of Chocolate objects.
//  The magic of BehaviorRelay comes from a method called asObservable(). Instead of manually checking value every time, you can add an Observer to keep an eye on the value for you. When the value changes, the Observer lets you know so you can react to any updates.
//  The downside is that if you need to access or change something in that array of chocolates, you must do it via accept(_:). This method on BehaviorRelay updates its value property.
  let chocolates: BehaviorRelay<[Chocolate]> = BehaviorRelay(value: [])
}

//MARK: Non-Mutating Functions
extension ShoppingCart {
  var totalCost: Float {
    return chocolates.value.reduce(0) {
      runningTotal, chocolate in
      return runningTotal + chocolate.priceInDollars
    }
  }
  
  var itemCountString: String {
    guard chocolates.value.count > 0 else {
      return "🚫🍫"
    }
    
    //Unique the chocolates
    let setOfChocolates = Set<Chocolate>(chocolates.value)
    
    //Check how many of each exists
    let itemStrings: [String] = setOfChocolates.map {
      chocolate in
      let count: Int = chocolates.value.reduce(0) {
        runningTotal, reduceChocolate in
        if chocolate == reduceChocolate {
          return runningTotal + 1
        }
        
        return runningTotal
      }
      
      return "\(chocolate.countryFlagEmoji)🍫: \(count)"
    }
    
    return itemStrings.joined(separator: "\n")
  }
}
