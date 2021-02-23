import Foundation
import Reusable
import MGArchitecture
import RxSwift
import RxCocoa

struct VideoRecipeViewModel {
    let navigator: VideoRecipeNavigatorType
    let usecase: VideoRecipeUseCaseType
    let recipe: Recipe
}

extension VideoRecipeViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let goBackTrigger: Driver<Void>
    }
    
    struct Output {
        @Property var video = Videos()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.goBackTrigger
            .do(onNext: navigator.goBackDetailView)
            .drive()
            .disposed(by: disposeBag)
        
        input.loadTrigger
            .flatMapLatest {
                usecase.getVideooOfRecipe(query: recipe.title).asDriverOnErrorJustComplete()
            }
            .drive(output.$video)
            .disposed(by: disposeBag)
        
        return output
    }
}
