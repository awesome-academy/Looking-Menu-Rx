import Foundation
import RxSwift
import RxCocoa
import MGArchitecture
import NSObject_Rx
import UIKit

enum ConstantCalor {
    static let calorieMale = 5
    static let calorieFemale = -161
    static let calorieHeight = 6.25
    static let calorieWeight = 10.0
    static let calorieAge = 5
}

enum Activities: String {
    static let allCases = [
        sedentary,
        light,
        moderate,
        activez,
        very,
        extra
    ]
    
    case sedentary =  "Sedentary: little or no exercise"
    case light = "Light: exercise 1-3 times/week"
    case moderate = "Moderate: exercise 4-5 times/week"
    case activez = "Active: daily exercise or intense exercise 3-4 times/week"
    case very = "Very Active: intense exercise 6-7 times/week"
    case extra = "Extra Active: very intense exercise daily, or physical job"
    
    var activityValue: Double {
        switch self {
        case .sedentary: return 1.232
        case .light: return 1.411
        case .moderate: return 1.504
        case .activez: return 1.591
        case .very: return 1.771
        case .extra: return 1.950
        }
    }
}

struct AddDietViewModel {
    let navigator: AddDietNavigatorType
    let usecase: AddDietUseCaseType
}

extension AddDietViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let textFieldTrigger: Driver<(String, String, String)>
        let tapGenreButton: Driver<Void>
        let tapDropDownButton: Driver<Void>
        let selectTrigger: Driver<IndexPath>
        let createDietButton: Driver<Void>
        let goBackTrigger: Driver<Void>
    }
    
    struct Output {
        @Property var activities = Activities.allCases
        @Property var isDropdown = true
        @Property var enableButton = false
        @Property var genreUser = true
        @Property var titleActivityButton = Activities.sedentary
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.textFieldTrigger
            .map { !(!$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty) }
            .drive(output.$enableButton)
            .disposed(by: disposeBag)
        
        input.tapGenreButton
            .map { _ in
                !output.genreUser
            }
            .drive(output.$genreUser)
            .disposed(by: disposeBag)
        
        input.tapDropDownButton
            .map { _ in
                !output.isDropdown
            }
            .drive(output.$isDropdown)
            .disposed(by: disposeBag)
        
        select(trigger: input.selectTrigger, items: output.$activities.asDriver())
            .do { _ in
                output.$isDropdown.accept(true)
            }
            .drive(output.$titleActivityButton)
            .disposed(by: disposeBag)
        
        input.createDietButton
            .withLatestFrom(input.textFieldTrigger) {
                usecase.calculatorCalor(
                    height: $1.0,
                    weight: $1.1,
                    age: $1.2,
                    genre: output.genreUser,
                    activity: output.titleActivityButton)
            }
            .flatMapLatest {
                usecase
                    .getRecipeDiet(calor: $0)
                    .asDriverOnErrorJustComplete()
            }
            .map { usecase.createRecipeDietForSession(list: $0) }
            .flatMapLatest {
                navigator
                    .showAlertAdd(recipes: $0)
                    .asDriverOnErrorJustComplete()
            }
            .flatMapLatest { usecase.addDiet(diet: $0).asDriverOnErrorJustComplete() }
            .do { _ in
                NotificationCenter().postEvent("addDiet")
                navigator.goBackView()
            }
            .drive()
            .disposed(by: disposeBag)
        
        input.goBackTrigger
            .do (onNext: navigator.goBackView)
            .drive()
            .disposed(by: disposeBag)
        
        return output
    }
}
