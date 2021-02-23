import Foundation
import RxSwift
import RxCocoa
import MGArchitecture

struct TextRecipeViewModel {
    let navigator: TextRecipeNavigatorType
    let usecase: TextRecipeUseCaseType
    let recipe: Recipe
}

extension TextRecipeViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let goBackTrigger: Driver<Void>
    }
    
    struct Output {
        @Property var information = Information()
        @Property var steps = [Step]()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.loadTrigger
            .flatMapLatest {
                usecase.getInfomationRecipe(id: recipe.id)
                    .asDriverOnErrorJustComplete()
            }
            .drive(output.$information)
            .disposed(by: disposeBag)
        
        output.$information
            .asDriver()
            .map{ $0.analyzedInstructions.first?.steps ?? [Step]() }
            .drive(output.$steps)
            .disposed(by: disposeBag)
        
        input.goBackTrigger
            .do(onNext: navigator.goBackDetail)
            .drive()
            .disposed(by: disposeBag)
        
        return output
    }
}
