import Foundation
import RxSwift
import RxCocoa
import MGArchitecture

struct HomeViewModel {
    let navigator: HomeNavigatorType
    let useCase: HomeUseCaseType
}

extension HomeViewModel: ViewModel {
    
    struct Input {
        let loadView: Driver<Void>
        let selectRecipe: Driver<IndexPath>
        let textSearchBar: Driver<String>
        let endEditSeachBar: Driver<Void>
        let tapSearchButton: Driver<Void>
    }
    
    struct Output {
        @Property var recipes = [Recipe]()
        @Property var isLoading = Bool()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.loadView
            .flatMapLatest { _ in
                useCase
                    .getRandomRecipe()
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: { _ in
                output.$isLoading.accept(false)
            })
            .drive(output.$recipes)
            .disposed(by: disposeBag)
        
        Driver
            .merge(input.tapSearchButton, input.endEditSeachBar)
            .withLatestFrom(input.textSearchBar) { $1 }
            .do { navigator.toSearchView(query: $0) }
            .drive()
            .disposed(by: disposeBag)
        
        input.selectRecipe
            .withLatestFrom(output.$recipes.asDriver()) { $1[$0.item] }
            .do { navigator.toRecipeDetail(recipe: $0) }
            .drive()
            .disposed(by: disposeBag)
        
        return output
    }
}
