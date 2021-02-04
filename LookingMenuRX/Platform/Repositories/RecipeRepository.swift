import Foundation
import RxSwift

protocol RecipeRepositoryType {
    func getRandomRecipe(input: RandomRecipeRequest) -> Observable<RecipesResponse>
    func getStepTaskRecipe(input: InformationRecipeRequest) -> Observable<InformationResponse>
    func getIngredientRecipe(input: DetailIngredientRequest) -> Observable<IngredientsResponse>
    func getEquipmentRecipe(input: DetailEquipmentRequest) -> Observable<EquipmentsResponse>
    func getRecipeNutrient(input: RecipesNutrientRequest) -> Observable<[RecipeDietResponse]>
}

struct RecipeRepository: RecipeRepositoryType {
    
    private let api: APIService = APIService.share
    
    func getRandomRecipe(input: RandomRecipeRequest) -> Observable<RecipesResponse> {
        api.request(input: input)
    }
    
    func getStepTaskRecipe(input: InformationRecipeRequest) -> Observable<InformationResponse> {
        api.request(input: input)
    }
    
    func getIngredientRecipe(input: DetailIngredientRequest) -> Observable<IngredientsResponse> {
        api.request(input: input)
    }
    
    func getEquipmentRecipe(input: DetailEquipmentRequest) -> Observable<EquipmentsResponse> {
        api.request(input: input)
    }
    
    func getRecipeNutrient(input: RecipesNutrientRequest) -> Observable<[RecipeDietResponse]> {
        api.requestArray(input: input)
    }
}
