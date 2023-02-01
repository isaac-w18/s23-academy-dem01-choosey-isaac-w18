import Foundation
import SwiftUI

class BusinessListViewModel: ObservableObject {
    @Published var searchTerm: String = ""
    @Published var radius: Int = 1
    
    @Published var businesses: [Business] = []
    @Published var highestRatedId: String? = nil
    
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var isLoading: Bool = false
  
    func getPlaces() {
        // MARK: Add logic to clear businesses array and return from function here
        if(searchTerm.isEmpty) {
            businesses.removeAll()
            return
        }
        
        YelpService.getBusinesses(term: searchTerm, radius: radius) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let businesses):
                    self.businesses = businesses
                    self.highestRatedId = self.getBestRestaurantId(businesses: businesses)
                    
                case .failure(let error):
                    self.errorMessage = error.rawValue
                    self.showError = true
                }
            }
        }
    }
    
    func getBestRestaurantId(businesses: [Business]) -> String? {
        if businesses.isEmpty {
            return nil
        }
        
        var best = businesses[0]
        
        for business in businesses {
            if business.rating > best.rating {
                best = business
            }
        }
        return best.id
    }
}


