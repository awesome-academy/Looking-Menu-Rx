import Foundation
import RxSwift
import RxCocoa
import MGArchitecture

struct FavouriteViewModel {
    let usecase: FavouriteUseCaseType
    let navigator: FavouriteNavigatorType
}

extension FavouriteViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let notification: Driver<Notification>
        let selectTrigger: Driver<IndexPath>
        let deleteTrigger: Driver<IndexPath>
    }
    
    struct Output {
        @Property var recipes = [Recipe]()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input
            .loadTrigger
            .flatMapLatest { _ in
                usecase.getAllRecipeFavourite().asDriverOnErrorJustComplete()
            }
            .drive(output.$recipes)
            .disposed(by: disposeBag)
        
        select(trigger: input.selectTrigger, items: output.$recipes.asDriver())
            .do { navigator.goDetailView(recipe: $0) }
            .drive()
            .disposed(by: disposeBag)
    
        select(trigger: input.deleteTrigger, items: output.$recipes.asDriver())
            .do { (recipe) in
                output.$recipes.accept(output.recipes.filter{ $0.id != recipe.id })
            }
            .flatMapLatest{ usecase.deleteRecipeFavourite(id: $0.id).asDriverOnErrorJustComplete() }
            .drive()
            .disposed(by: disposeBag)
        
        input.notification
            .flatMapLatest { _ in
                usecase.getAllRecipeFavourite().asDriverOnErrorJustComplete()
            }
            .do { output.$recipes.accept($0) }
            .drive()
            .disposed(by: disposeBag)
        
        return output
    }
}
