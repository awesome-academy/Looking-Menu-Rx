import Foundation
import RxSwift
import RxCocoa

protocol HomeUseCaseType {
    func getRandomRecipe() -> Observable<[Recipe]>
}

struct HomeUseCase: HomeUseCaseType {
    func getRandomRecipe() -> Observable<[Recipe]> {
        let request = RandomRecipeRequest(offset: 5)
        let repository = RecipeRepository()
        return repository.getRandomRecipe(input: request)
    }
}
