import Foundation
import UIKit
import RxSwift
import RxCocoa
import MGArchitecture

struct SearchViewModel {
    let usecase: SearchViewUseCaseType
    let navigator: SearchViewNavigatorType
    let keyWord: String
    let typeSearch: TypeSearch
}

extension SearchViewModel: ViewModel {
    struct Input {
        let textSearch: Driver<String>
        let selectRecipe: Driver<IndexPath>
        let backTrigger: Driver<Void>
    }
    
    struct Output {
        @Property var recipes = [Recipe]()
        @Property var isEmptyRecipes = Bool()
        @Property var isLoading = true
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.textSearch
            .throttle(.microseconds(300))
            .startWith(keyWord)
            .distinctUntilChanged()
            .flatMapLatest {
                usecase.searchRecipe(keyWord: $0, typeSearch: typeSearch)
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: { _ in
                output.$isLoading.accept(false)
            })
            .drive(output.$recipes)
            .disposed(by: disposeBag)
        
        select(trigger: input.selectRecipe, items: output.$recipes.asDriver())
            .do { navigator.goDetailView(recipe: $0) }
            .drive()
            .disposed(by: disposeBag)
        
        output.$recipes
            .map{ $0.isEmpty }
            .asDriverOnErrorJustComplete()
            .drive(output.$isEmptyRecipes)
            .disposed(by: disposeBag)
        
        input.backTrigger
            .asDriver()
            .do { _ in
                navigator.goBackView()
            }
            .drive()
            .disposed(by: disposeBag)
        
        return output
    }
}
