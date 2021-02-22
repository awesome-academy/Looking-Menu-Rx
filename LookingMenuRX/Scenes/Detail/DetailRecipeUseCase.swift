import Foundation
import RxSwift
import RxCocoa

protocol DetailRecipeUseCaseType {
    func getIngredientRecipe(id: Int) -> Observable<[Detail]>
    func getEquipmentRecipe(id: Int) -> Observable<[Detail]>
    func checkRecipeFavourite(id: Int) -> Observable<Bool>
    func addRecipeFavourite(recipe: Recipe) -> Observable<Bool>
    func deleteRecipeFavourite(id: Int) -> Observable<Bool>
}

struct DetailRecipeUseCase: DetailRecipeUseCaseType {
    let favouriteRepository = FavouriteRepository()
    let recipeRepository = RecipeRepository()
    
    func deleteRecipeFavourite(id: Int) -> Observable<Bool> {
        return favouriteRepository.deleteFavouriteRecipe(idRecipe: id).andThen(.just(false))
    }
    
    func addRecipeFavourite(recipe: Recipe) -> Observable<Bool> {
        return favouriteRepository.addFavouriteRecipe(recipe: recipe).andThen(.just(true))
    }
    
    func checkRecipeFavourite(id: Int) -> Observable<Bool> {
        return favouriteRepository.checkFavouriteRecipe(idRecipe: id)
    }
    
    func getIngredientRecipe(id: Int) -> Observable<[Detail]> {
        let request = DetailIngredientRequest(idRecipe: id)
        return recipeRepository.getIngredientRecipe(input: request)
    }
    
    func getEquipmentRecipe(id: Int) -> Observable<[Detail]> {
        let request = DetailEquipmentRequest(idRecipe: id)
        return recipeRepository.getEquipmentRecipe(input: request)
    }
}
