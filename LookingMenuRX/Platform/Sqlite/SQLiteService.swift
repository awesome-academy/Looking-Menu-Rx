import Foundation
import SQLite3
import ObjectMapper
import RxSwift

private enum ConstantSqlite {
    static let path = "LookingMenu.sqlite"
    static let queryCreateTableDiet = "CREATE TABLE IF NOT EXISTS Diet(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT,  calor REAL, recipeSessions TEXT);"
    static let queryCreateTableDietFavourite = "CREATE TABLE IF NOT EXISTS FavouriteRecipe(id INTEGER PRIMARY KEY, title TEXT, readyInMinutes Integer, image TEXT);"
    static let queryInsertDataDiet = "INSERT INTO Diet (name, calor, recipeSessions) VALUES (?, ?, ?);"
    static let queryReadDataDiet = "SELECT * FROM Diet"
    static let queryDeleteDataDiet =  "DELETE FROM Diet WHERE id=?;"
    static let queryReadDataDietFavourite = "SELECT * FROM FavouriteRecipe"
    static let queryCheckDataDietFavourite = "SELECT * FROM FavouriteRecipe WHERE id=?;"
    static let queryInsertDataDietFavourite =
        "INSERT INTO FavouriteRecipe (id, title, readyInMinutes, image) VALUES (?, ?, ?, ?);"
    static let queryDeleteDataDietFavourite = "DELETE FROM FavouriteRecipe WHERE id=?;"
}

class SQLiteService {
    var db: OpaquePointer?
    init() {
        db = createDatabaseLookingMenu()
    }
    
    func createDatabaseLookingMenu() -> OpaquePointer? {
        guard let filePath = try? FileManager.default.url(for: .documentDirectory,
                                                          in: .userDomainMask,
                                                          appropriateFor: nil,
                                                          create: false)
                .appendingPathExtension(ConstantSqlite.path)
        else { return nil }
        var db: OpaquePointer? = nil
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            return nil
        } else {
            return db
        }
    }
    
    func createTableDiet()  {
        let query = ConstantSqlite.queryCreateTableDiet
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_step(statement)
        } else {
            print("Prepration fail")
        }
    }
    
    func createTableDietFavourite()  {
        let query = ConstantSqlite.queryCreateTableDietFavourite
        
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_step(statement)
        } else {
            print("Prepration fail")
        }
    }
    
    func insertQueryDiet(
        name: String,
        calorie: Double,
        recipeSessions: [RecipeSession]) -> Completable {
        return Completable.create { completable in
            let query = ConstantSqlite.queryInsertDataDiet
            var statement: OpaquePointer? = nil
            
            if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_text(statement, 1, (name as NSString).utf8String, -1, nil)
                sqlite3_bind_double(statement, 2, Double(calorie))
                let data = Mapper().toJSONString(recipeSessions, prettyPrint: true)
                let listString = data?.cString(using: String.Encoding.utf8)
                sqlite3_bind_text(statement, 3, listString, -1, nil)
                sqlite3_step(statement)
                completable(.completed)
            } else {
                completable(.error(SqliteError.addFail))
            }
            sqlite3_finalize(statement)
            return Disposables.create()
        }
    }
    
    func readTableDiet() -> Observable<[Diet]> {
        return Observable.create { observer in
            var result = [Diet]()
            let query = ConstantSqlite.queryReadDataDiet
            var statement: OpaquePointer? = nil
            if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let id = Int(sqlite3_column_int(statement, 0))
                    let name = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                    let calor = Double(sqlite3_column_double(statement, 2))
                    let list = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                    let recipes = list.data(using: .utf8) ?? Data()
                    let data = recipes.compactMap { (UInt8) -> RecipeSession in
                        return (Mapper<RecipeSession>().map(JSONObject: UInt8) ?? RecipeSession())
                    }
                    let element = Diet(id: id,
                                       name: name,
                                       calor: calor,
                                       recipeSessions: data)
                    result.append(element)
                }
                observer.onNext(result)
                observer.onCompleted()
            } else {
                observer.onError(SqliteError.readFail)
            }
            return Disposables.create()
        }
    }
    
    func deleteDiet(idDiet: Int) -> Completable {
        return Completable.create { completable in
            let query = ConstantSqlite.queryDeleteDataDiet
            var statement: OpaquePointer? = nil
            if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_int(statement, 1, Int32(idDiet))
                sqlite3_step(statement)
                completable(.completed)
            } else {
                completable(.error(SqliteError.deleteFail))
            }
            sqlite3_finalize(statement)
            return Disposables.create()
        }
    }
    
    func checkRecipeFavourite(idDiet: Int) -> Observable<Bool> {
        return Observable.create { observer in
            var result = false
            let query = ConstantSqlite.queryCheckDataDietFavourite
            var statement: OpaquePointer? = nil
            if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) ==
                SQLITE_OK {
                sqlite3_bind_int(statement, 1, Int32(idDiet))
                if sqlite3_step(statement) == SQLITE_ROW {
                    result = true
                }
                observer.onNext(result)
                observer.onCompleted()
            } else {
                observer.onError(SqliteError.readFail)
            }
            sqlite3_finalize(statement)
            return Disposables.create()
        }
    }
    
    func insertRecipeFavourite(id: Int, title: String, readyInMinutes: Int, image: String)
    -> Completable {
        return Completable.create { completable in
            let query = ConstantSqlite.queryInsertDataDietFavourite
            var statement: OpaquePointer? = nil
            if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_int(statement, 1, Int32(id))
                sqlite3_bind_text(statement, 2, (title as NSString).utf8String, -1, nil)
                sqlite3_bind_int(statement, 3, Int32(readyInMinutes))
                sqlite3_bind_text(statement, 4, (image as NSString).utf8String, -1, nil)
                sqlite3_step(statement)
                completable(.completed)
            } else {
                completable(.error(SqliteError.addFail))
            }
            sqlite3_finalize(statement)
            return Disposables.create()
        }
    }
    
    func deleteDietFavourite(idDiet: Int) -> Completable {
        return Completable.create { completable in
            let query = ConstantSqlite.queryDeleteDataDietFavourite
            var statement: OpaquePointer? = nil
            if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_int(statement, 1, Int32(idDiet))
                sqlite3_step(statement)
                completable(.completed)
            } else {
                completable(.error(SqliteError.deleteFail))
            }
            sqlite3_finalize(statement)
            return Disposables.create()
        }
    }
    
    func readTableDietFavourite() -> Observable<[Recipe]> {
        return Observable.create { observer in
            var result = [Recipe]()
            let query = ConstantSqlite.queryReadDataDietFavourite
            var statement: OpaquePointer? = nil
            if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let id = Int(sqlite3_column_int(statement, 0))
                    let title = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                    let readyInMinutes = Int(sqlite3_column_int(statement, 2))
                    let image = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                    result.append(Recipe(id: id,
                                         title: title,
                                         readyInMinutes: readyInMinutes,
                                         image: image))
                }
                observer.onNext(result)
                observer.onCompleted()
            } else {
                observer.onError(SqliteError.readFail)
            }
            return Disposables.create()
        }
    }
}
