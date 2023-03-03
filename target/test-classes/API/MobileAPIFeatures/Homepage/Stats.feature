@Stats

Feature: stats
  Background: Background Variables
    * url startingURL
    * def JavaData = Java.type('com.veritec.automation.JavaFunctionsAPI.DataReader.EnvConfig')
    * def JavaFunctions = Java.type('com.veritec.automation.JavaFunctionsAPI.ReusableFunctions')
    * def payloadsData = read('../../payloads/devDataAPI.json')
    * def pathsTo = read('../../support/paths.json')
    * def paramsTo = read('../../support/params.json')
    * def headersTo = read('../../support/headers.json')
    * def headersToBeUsed = headersTo.CommonHeaders
    * def featureToBeUsed = read('../Login/Login.feature@ValidUserLogin')
    * def result = call featureToBeUsed
    * def headersToBeUsed = headersTo.CommonHeaders
    * headersToBeUsed["Authorization"] = result.accessToken

  @GET @Stats
  Scenario: API for Main Homepage (v4)

    * def parameters = paramsTo.MainHomePageParams
    Given path pathsTo.MobileAPI.Stats
    And params parameters
    And headers headersToBeUsed
    When method GET
    Then status 200
    And match response.status_code == 200
    And match response.message == "Success"
    * string jsonResponse = response
    * string JSONSchemaExpected = read('../../schemas/mainHomePageSchema.json')
    * assert JavaFunctions.isValid(jsonResponse,JSONSchemaExpected)

