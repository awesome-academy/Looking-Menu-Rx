import Foundation
import RxSwift

protocol SearchRepositoryType {
    func searchVideoRecipe(input: SearchVideoRequest) -> Observable<VideosResponse>
    func searchRecipeByName(input: SearchByNameRequest) -> Observable<ResultSearchResponse>
    func searchRecipeByIngredient(
        input: SearchRecipesIngredientRequest) -> Observable<[ResultSearchByIngredientsResponse]>
}

struct SearchRepository: SearchRepositoryType {
    
    private let api: APIService = APIService.share
    
    func searchVideoRecipe(input: SearchVideoRequest) -> Observable<VideosResponse> {
        api.request(input: input)
    }
    
    func searchRecipeByName(input: SearchByNameRequest) -> Observable<ResultSearchResponse> {
        api.request(input: input)
    }
    
    func searchRecipeByIngredient(input: SearchRecipesIngredientRequest) -> Observable<[ResultSearchByIngredientsResponse]> {
        api.requestArray(input: input)
    }
}
