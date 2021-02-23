import Foundation
import RxSwift
import RxCocoa
import MGArchitecture
import NSObject_Rx

struct DietViewModel {
    let usecase: DietUseCaseType
    let navigator: DietNavigatorType
}

extension DietViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let goAddDietTrigger: Driver<Void>
        let tapDropdown: Driver<Void>
        let selectTrigger: Driver<IndexPath>
        let selectSession: Driver<Int>
        let selectDateTrigger: Driver<Date>
        let notification: Driver<Notification>
        let deleteTrigger: Driver<IndexPath>
        let goDetailTrigger: Driver<Void>
    }
    
    struct Output {
        @Property var diets = [Diet]()
        @Property var selectDiet = Diet()
        @Property var selectDateDiet = [RecipeDiet]()
        @Property var selectSessionRecipe = RecipeDiet()
        @Property var isDropDown = true
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        let selectIndexSession = BehaviorRelay<Int>(value: 0)
        let selectDateSession = BehaviorRelay<Date>(value: Date())
        
        input.loadTrigger
            .flatMapLatest { _ in
                usecase.getAllDiet().asDriverOnErrorJustComplete()
            }
            .do {
                output.$selectDiet.accept($0[0])
                output.$selectDateDiet.accept($0[0].recipeSessions[0].recipes)
            }
            .drive(output.$diets)
            .disposed(by: disposeBag)
        
        input.goAddDietTrigger
            .do(onNext: navigator.goAddDietView)
            .drive()
            .disposed(by: disposeBag)
        
        input.tapDropdown
            .map { _ in
                !output.isDropDown
            }
            .drive(output.$isDropDown)
            .disposed(by: disposeBag)
        
        select(trigger: input.selectTrigger, items: output.$diets.asDriver())
            .do {
                output.$isDropDown.accept(true)
                output.$selectDiet.accept($0)
                output.$selectDateDiet.accept(usecase.getDietOnDate(recipeSession: output.selectDiet.recipeSessions, date: selectDateSession.value))
                output.$selectSessionRecipe.accept(output.selectDateDiet[selectIndexSession.value])
            }
            .drive()
            .disposed(by: disposeBag)
        
        input.selectSession.asDriver()
            .do { selectIndexSession.accept($0) }
            .map { output.selectDateDiet[$0] }
            .drive ( output.$selectSessionRecipe )
            .disposed(by: disposeBag)
        
        input.selectDateTrigger
            .do { selectDateSession.accept($0) }
            .map {
                usecase.getDietOnDate(recipeSession: output.selectDiet.recipeSessions, date: $0)
            }
            .do {
                if $0.isEmpty {
                    navigator.showAlertError()
                    output.$selectDateDiet.accept(output.selectDiet.recipeSessions[0].recipes)
                } else {
                    output.$selectDateDiet.accept($0)
                }
                output.$selectSessionRecipe.accept(output.selectDateDiet[selectIndexSession.value])
            }
            .drive()
            .disposed(by: disposeBag)
        
        input.notification
            .flatMapLatest { _ in
                usecase.getAllDiet().asDriverOnErrorJustComplete()
            }
            .do { output.$diets.accept($0) }
            .drive()
            .disposed(by: disposeBag)
        
        input.deleteTrigger
            .withLatestFrom(output.$diets.asDriver()) { $1[$0.row] }
            .do { (recipe) in
                output.$diets.accept(output.diets.filter{ $0.id != recipe.id })
            }
            .flatMapLatest {
                usecase.deleteDiet(id: $0.id).asDriverOnErrorJustComplete()
            }
            .drive()
            .disposed(by: disposeBag)
        
        input.goDetailTrigger
            .do { _ in
                let recipe = output.selectSessionRecipe
                navigator.goDetailView(recipe: Recipe (
                                        id: recipe.id,
                                        title: recipe.title,
                                        readyInMinutes: 0,
                                        image: recipe.image))
            }
            .drive()
            .disposed(by: disposeBag)
        
        return output
    }
}
