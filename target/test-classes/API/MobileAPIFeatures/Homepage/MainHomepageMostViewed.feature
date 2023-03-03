@MainHomepage @MostViewed

Feature: Main Homepage v2 Most Viewed API
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

  @MobileApiTest @GetMainHomepageMostViewed @Regression @Sanity @Smoke @Mobile @GET
  Scenario: API for Main Homepage Most Viewed (v2)

    * def parameters = paramsTo.MainHomePageMostViewedParams
    Given path pathsTo.MobileAPI.MainHomePageMostViewed
    And params parameters
    And headers headersToBeUsed
    When method GET
    Then status 200
    And match response.status_code == 200
    And match response.message == "Success"
    And match response.meta_data.from == 0
    And match response.meta_data.limit == 5
    * string jsonResponse = response
    * string JSONSchemaExpected = read('../../schemas/mainHomepageMostViewedSchema.json')
    * assert JavaFunctions.isValid(jsonResponse,JSONSchemaExpected)

  @MobileApiTest @GetMainHomepageMostViewedCustomLimit @Regression @Sanity @Smoke @Mobile @GET
  Scenario: API for Main Homepage Most Viewed (v2) with custom limit

    * def parameters = paramsTo.MainHomePageCustomLimitParams
    Given path pathsTo.MobileAPI.MainHomePageMostViewed
    And params parameters
    And headers headersToBeUsed
    When method GET
    Then status 200
    And match response.status_code == 200
    And match response.message == "Success"
    And match response.meta_data.from == 0
    And match response.meta_data.limit == 2

  @MobileApiTest @GetMainHomepageMostViewedWithoutParams @Regression @Sanity @Smoke @Mobile @GET
  Scenario: API for Main Homepage Most Viewed (v2) without parameters

    Given path pathsTo.MobileAPI.MainHomePageMostViewed
    And headers headersToBeUsed
    When method GET
    Then status 200
    And match response.status_code == 200
    And match response.message == "Success"


  @MobileApiTest @GetMainHomepageMostViewedWithoutAuth @Regression @Sanity @Smoke @Mobile @GET
  Scenario: API for Main Homepage Most Viewed (v2) without Authorization
    * headersToBeUsed["Authorization"] = ''
    * def parameters = paramsTo.MainHomePageMostViewedParams
    Given path pathsTo.MobileAPI.MainHomePageMostViewed
    And params parameters
    And headers headersToBeUsed
    When method GET
    Then status 403
    And match response.status_code == 403
    And match response.message == "A token is required for authentication"