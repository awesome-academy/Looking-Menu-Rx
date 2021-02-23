import Foundation
import RxSwift
import RxCocoa
import MGArchitecture

protocol TextRecipeUseCaseType {
    func getInfomationRecipe(id: Int) -> Observable<Information>
}

struct TextRecipeUseCase: TextRecipeUseCaseType {
    let repository = RecipeRepository()
    
    func getInfomationRecipe(id: Int) -> Observable<Information> {
        let request = InformationRecipeRequest(idRecipe: id)
        return repository.getInfomationRecipe(input: request)
    }
}
