import Foundation
import MGArchitecture
import RxSwift
import RxCocoa

struct DetailRecipeViewModel {
    let navigator: DetailRecipeNavigatorType
    let usecase: DetailRecipeUseCaseType
    let recipe: Recipe
}

extension DetailRecipeViewModel: ViewModel {
    
    struct Input {
        let loadTrigger: Driver<Void>
        let tapFavouriteButton: Driver<Void>
        let tapGoVideo: Driver<Void>
        let tapGoText: Driver<Void>
        let backTrigger: Driver<Void>
    }
    
    struct Output {
        @Property var equipmentTrigger = [Detail]()
        @Property var ingredientTrigger = [Detail]()
        @Property var isFavourite = Bool()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.loadTrigger.flatMapLatest { _ in
            usecase
                .getEquipmentRecipe(id: recipe.id)
                .asDriverOnErrorJustComplete()
        }
        .drive(output.$equipmentTrigger)
        .disposed(by: disposeBag)
        
        input.loadTrigger.flatMapLatest { _ in
            usecase
                .getIngredientRecipe(id: recipe.id)
                .asDriverOnErrorJustComplete()
        }
        .drive(output.$ingredientTrigger)
        .disposed(by: disposeBag)
        
        input.loadTrigger.flatMapLatest { _ in
            usecase
                .checkRecipeFavourite(id: recipe.id)
                .asDriverOnErrorJustComplete()
        }
        .drive(output.$isFavourite)
        .disposed(by: disposeBag)
        
        input.tapFavouriteButton
            .flatMapLatest {
                output.isFavourite ?
                    usecase.deleteRecipeFavourite(id: recipe.id).asDriverOnErrorJustComplete() :
                    usecase.addRecipeFavourite(recipe: recipe).asDriverOnErrorJustComplete()
            }
            .do { _ in
                NotificationCenter().postEvent("addFavourite")
            }
            .drive(output.$isFavourite)
            .disposed(by: disposeBag)
        
        input.tapGoVideo
            .do { _ in
                navigator.goDetailVideo(recipe: recipe)
            }
            .drive()
            .disposed(by: disposeBag)
        
        input.tapGoText
            .do { _ in
                navigator.goDetailText(recipe: recipe)
            }
            .drive()
            .disposed(by: disposeBag)
        
        input.backTrigger
            .do(onNext: navigator.goBackView)
            .drive()
            .disposed(by: disposeBag)
        
        return output
    }
}
