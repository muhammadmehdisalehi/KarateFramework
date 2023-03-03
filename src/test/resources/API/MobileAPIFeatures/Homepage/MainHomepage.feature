@MainHomepage

Feature: Main Homepage v4 API
  Background: Background Variables
    * url startingURL+'homemedia'+endingUrl
    * def JavaData = Java.type('com.jogo.automation.JavaFunctionsAPI.DataReader.EnvConfig')
    * def JavaFunctions = Java.type('com.jogo.automation.JavaFunctionsAPI.ReusableFunctions')
    * def payloadsData = read('../../payloads/devDataAPI.json')
    * def pathsTo = read('../../support/paths.json')
    * def paramsTo = read('../../support/params.json')
    * def headersTo = read('../../support/headers.json')
    * def headersToBeUsed = headersTo.CommonHeaders
    * def featureToBeUsed = read('../Login/Login.feature@ValidUserLogin')
    * def result = call featureToBeUsed
    * def headersToBeUsed = headersTo.CommonHeaders
    * headersToBeUsed["Authorization"] = result.accessToken

  @MobileApiTest @GetMainHomepage @Regression @Sanity @Smoke @Mobile @GET
    Scenario: API for Main Homepage (v4)

    * def parameters = paramsTo.MainHomePageParams
    Given path pathsTo.MobileAPI.MainHomePage
    And params parameters
    And headers headersToBeUsed
    When method GET
    Then status 200
    And match response.status_code == 200
    And match response.message == "Success"
    * string jsonResponse = response
    * string JSONSchemaExpected = read('../../schemas/mainHomePageSchema.json')
    * assert JavaFunctions.isValid(jsonResponse,JSONSchemaExpected)

  @MobileApiTest @GetMainHomepageWithoutParams @Regression @Sanity @Smoke @Mobile @GET
  Scenario: API for Main Homepage (v4) without parameters

    Given path pathsTo.MobileAPI.MainHomePage
    And headers headersToBeUsed
    When method GET
    Then status 200
    And match response.status_code == 200
    And match response.message == "Success"


  @MobileApiTest @GetMainHomepageWithoutAuth @Regression @Sanity @Smoke @Mobile @GET
  Scenario: API for Main Homepage (v4) without Auth
    * headersToBeUsed["Authorization"] = ''
    * def parameters = paramsTo.MainHomePageParams
    Given path pathsTo.MobileAPI.MainHomePage
    And params parameters
    And headers headersToBeUsed
    When method GET
    Then status 403
    And match response.status_code == 403
    And match response.message == "A token is required for authentication"




