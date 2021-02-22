import RxSwift
import RxCocoa
import Foundation

protocol SearchViewUseCaseType {
    func searchRecipe(keyWord: String, typeSearch: TypeSearch) -> Observable<[Recipe]>
}

struct SearchViewUseCase: SearchViewUseCaseType {
    func searchRecipe(keyWord: String, typeSearch: TypeSearch) -> Observable<[Recipe]> {
        let repository = SearchRepository()
        if typeSearch == .searchName {
            let request = SearchByNameRequest(query: keyWord, offset: 10)
            return repository.searchRecipeByName(input: request)
        } else {
            let request = SearchRecipesIngredientRequest(ingredients: keyWord)
            return repository.searchRecipeByIngredient(input: request)
        }
    }
}
