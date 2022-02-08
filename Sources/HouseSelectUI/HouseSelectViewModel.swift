//
//  HouseSelectViewModel.swift
//  
//
//  Created by Nikolai Nobadi on 2/6/22.
//

public struct HouseSelectViewModel {
    
    // MARK: - Properties
    let selectType: HouseSelectType
    let createHouse: () -> Void
    let showJoinHouse: () -> Void
    
    var title: String {
        switch selectType {
        case .initialLogin: return "Welcome!"
        case .noHouse: return "Your House is missing!"
        case .switchHouse: return "Switch Household"
        }
    }
    
    var topDetails: String {
        selectType == .noHouse ? noHouseTopText : ""
    }
    
    var bottomDetails: String {
        switch selectType {
        case .initialLogin: return initialSignUpText
        case .noHouse: return noHouseBottomText
        case .switchHouse: return switchHouseText
        }
    }
    
    
    // MARK: - Init
    public init(selectType: HouseSelectType,
         createHouse: @escaping () -> Void,
         showJoinHouse: @escaping () -> Void) {
        
        self.selectType = selectType
        self.createHouse = createHouse
        self.showJoinHouse = showJoinHouse
    }
}


// MARK: - Private Helpers
private extension HouseSelectViewModel  {
    
    var initialSignUpText: String {
    """
    In order to share your tasks with other members of your household, you have to either create a household of your own, or join an existing one.



    Choose your fate!
    """
    }
    
    var noHouseTopText: String {
    """
    Either your household was deleted, or your internet connection is, uh, 'lacking'.

    You have three choices.
    """
    }
    
    var noHouseBottomText: String {
    """
    1. Restart the app when your connection improves
    2. Create a new house (you'll get starter tasks)
    3. Tap join to search for your house by its name or join someone else's.
    

    Fate smiles on those with clean houses!
    """
    }
    
    
    var switchHouseText: String {
    """
    Remember, you can always switch back to your old household, so long as you don't forget its name!
    """
    }
}

