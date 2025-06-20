@REQ_HU-0000 @ApiMarvel
Feature: Pruebas de API de Marvel

  Background:
    * configure ssl = true
    * def characterSchema = read('classpath:structures/structureCharacter.json')
    * def newCharacter = read('classpath:data/newCharacter.json')
    * def uniqueId = java.util.UUID.randomUUID().toString()
    * set newCharacter.name = newCharacter.name + '-' + uniqueId
    * def existCharacter = read('classpath:data/existCharacter.json')
    * def requiredCharacter = read('classpath:data/requiredCharacter.json')

  @id:1 @AllCharacters
  Scenario: T-API-HU-0000-CA1 Obtener todos los personajes de Marvel
    Given url baseUrl
    When method GET
    Then status 200
    And match response == '#[]'
    And match each response contains deep characterSchema

  @id:2 @CharacterByIdFound
  Scenario: T-API-HU-0000-CA2 Obtener un personaje de Marvel por id
    Given url baseUrl + "/" + idCharacter
    When method GET
    Then status 200
    And match response == characterSchema
    And match response.id == idCharacter

  @id:3 @CharacterByIdNotFound
  Scenario: T-API-HU-0000-CA3 Obtener un personaje de Marvel por id que no existe
    Given url baseUrl + "/280617"
    When method GET
    Then status 404
    And match response.error == "Character not found"

  @id:4 @CreateNewCharacter
  Scenario: T-API-HU-0000-CA4 Crear un personaje de Marvel
    Given url baseUrl
    And request
    """
    {
      "name": "#(newCharacter.name)",
      "alterego": "#(newCharacter.alterego)",
      "description": "#(newCharacter.description)",
      "powers": "#(newCharacter.powers)"
    }
    """
    When method POST
    Then status 201
    And match response == characterSchema
    * def createdCharacterId = response.id

  @id:5 @CreateExistCharacter
  Scenario: T-API-HU-0000-CA5 Crear un personaje de Marvel ya existente
    Given url baseUrl
    And request existCharacter
    When method POST
    Then status 400
    And match response.error == "Character name already exists"

  @id:6 @CreateCharacterRequiredFields
  Scenario: T-API-HU-0000-CA6 Crear un personaje de Marvel con campos requeridos
    Given url baseUrl
    And request
    """
    {
      "name": "",
      "alterego": "",
      "description": "",
      "powers": [ ]
    }
    """
    When method POST
    Then status 400
    And match response == requiredCharacter

  @id:7 @UpdateCharacter
  Scenario: T-API-HU-0000-CA7 Actualizar un personaje de Marvel
    Given url baseUrl + "/" + idCharacter
    And request
    """
    {
          "name": "Iron Man",
          "alterego": "Tony Stark",
          "description": "Updated description",
          "powers": [
            "Armor",
            "Flight"
          ]
        }
    """
    When method PUT
    Then status 200
    And match response == characterSchema
    And match response.id == idCharacter
    And match response.name == "Iron Man"

  @id:8 @UpdateCharacterNotFound
  Scenario: T-API-HU-0000-CA8 Actualizar un personaje de Marvel que no existe
    Given url baseUrl + "/280617"
    And request
    """
    {
      "name": "Iron Man",
      "alterego": "Tony Stark",
      "description": "Updated description",
      "powers": [
        "Armor",
        "Flight"
      ]
    }
    """
    When method PUT
    Then status 404
    And match response.error == "Character not found"

  @id:9 @DeleteCharacter
  Scenario: T-API-HU-0000-CA9 Eliminar un personaje de Marvel
    Given url baseUrl + "/" + idCharacter
    When method DELETE
    Then status 204
    * print response

  @id:10 @DeleteCharacterNotFound
  Scenario: T-API-HU-0000-CA10 Eliminar un personaje de Marvel que no existe
    Given url baseUrl + "/280617"
    When method DELETE
    Then status 404
    And match response.error == "Character not found"