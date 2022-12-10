//
//  CoreDataService.swift
//  StarWarsWorld
//
//  Created by Macbook on 09.12.2022.
//

import CoreData

/// Сервис работы с хранилищем.
protocol ICoreDataService {
    
    // MARK: - Methods
    
    /// Возвращает модели фильмов
    func getFilms() -> [FilmModel]
    
    /// Сохраняет модели фильмов
    func saveFilms(films: [FilmModel])
    
    /// Возвращает модели персонажей
    func getCharacters(urls: [String]) -> [CharacterModel]
    
    /// Сохраняет модели персонажей
    func saveCharacters(characters: [CharacterModel])
    
    /// Возвращает модель мира
    func getWorld(link: String) -> WorldModel?
    
    /// Сохраняет модель мира
    func saveWorld(world: WorldModel)
}

class CoreDataService: ICoreDataService {
    
    // MARK: - Dependencies
    
    let coreDataStack: ICoreDataStack
    
    // MARK: - Initialization
    
    init(coreDataStack: ICoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    // MARK: - ICoreDataService
    
    func getFilms() -> [FilmModel] {
        let fetchRequest: NSFetchRequest<Film> = Film.fetchRequest()
        let films = coreDataStack.fetch(fetchRequest: fetchRequest) ?? []
        var output: [FilmModel] = []
        films.forEach { film in
            guard let characters = film.links?.allObjects.compactMap({ character in
                let character = character as? CharacterLinks
                return character?.link
            }),
                    let title = film.title,
                    let director = film.director,
                    let producer = film.producer,
                    let date = film.releaseDate
            else { return }
            output.append(FilmModel(name: title, director: director, producer: producer, date: date, episode: Int(film.episodeId), characters: characters))
            
            }
        return output.sorted {$0.episode < $1.episode}
    }
    
    func saveFilms(films: [FilmModel]) {
        films.forEach { film in
            coreDataStack.performSave { context in
                let savingFilm = Film(context: context)
                savingFilm.title = film.name
                savingFilm.episodeId = Int16(film.episode)
                savingFilm.producer = film.producer
                savingFilm.director = film.director
                savingFilm.releaseDate = film.date
                film.characters.forEach { character in
                    let link = CharacterLinks(context: context)
                    link.link = character
                    savingFilm.addToLinks(link)
                }
            }
        }
    }
    
    func getCharacters(urls: [String]) -> [CharacterModel] {
        let characters = findCharacters(urls: urls)
        let output: [CharacterModel] = characters.compactMap { character in
            guard let name = character.name, let gender = character.gender, let birthYear = character.birthYear, let world = character.worldLink else { return nil }
            return CharacterModel(name: name, gender: gender, birthYear: birthYear, homeworld: world)
        }
        return output
    }
    
    func saveCharacters(characters: [CharacterModel]) {
        characters.forEach { character in
            coreDataStack.performSave { context in
                let savingCharacter = Character(context: context)
                savingCharacter.name = character.name
                savingCharacter.birthYear = character.birthYear
                savingCharacter.gender = character.gender
                savingCharacter.worldLink = character.homeworld
                savingCharacter.link = character.link
            }
        }
    }
    
    func getWorld(link: String) -> WorldModel? {
        guard let world = findWorld(link: link),
                let name = world.name,
                let gravity = world.gravity,
                let land = world.land,
                let diameter = world.diameter,
                let population = world.population,
                let climate = world.climate
        else { return nil }
        return WorldModel(link: link,
                          name: name,
                          gravity: gravity,
                          population: population,
                          landType: land,
                          climate: climate,
                          diameter: diameter)
    }
    
    func saveWorld(world: WorldModel) {
        coreDataStack.performSave { context in
            let savingWorld = World(context: context)
            savingWorld.diameter = world.diameter
            savingWorld.climate = world.climate
            savingWorld.gravity = world.gravity
            savingWorld.population = world.population
            savingWorld.name = world.name
            savingWorld.link = world.link
            savingWorld.land = world.landType
        }
    }
    
    // MARK: - Private Methods
    
    private func findWorld(link: String) -> World? {
        let fetchRequest: NSFetchRequest<World> = World.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "link = '\(link)'")
        guard let world = coreDataStack.fetch(fetchRequest: fetchRequest)?.first else { return nil }
        return world
    }
    
    private func findCharacters(urls: [String]) -> [Character] {
        var characters = [Character]()
        let fetchRequest: NSFetchRequest<Character> = Character.fetchRequest()
        for url in urls {
            fetchRequest.predicate = NSPredicate(format: "link = '\(url)'")
            guard let character = coreDataStack.fetch(fetchRequest: fetchRequest)?.first else { continue }
            characters.append(character)
        }
        return characters
    }
}
