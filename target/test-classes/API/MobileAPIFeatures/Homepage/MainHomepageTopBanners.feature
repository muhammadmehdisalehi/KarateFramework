@MainHomepage @TopBanners

Feature: Main Homepage v2 Top Banners API
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

  @MobileApiTest @GetMainHomepageTopBanners @Regression @Sanity @Smoke @Mobile @GET
  Scenario: API for Main Homepage Top Banners (v2)

    * def parameters = paramsTo.MainHomePageTopBannersParams
    Given path pathsTo.MobileAPI.MainHomePageTopBanners
    And params parameters
    And headers headersToBeUsed
    When method GET
    Then status 200
    And match response.status_code == 200
    And match response.message == "Success"
    And match response.meta_data.from == 0
    And match response.meta_data.limit == 10
    * string jsonResponse = response
    * string JSONSchemaExpected = read('../../schemas/mainHomepageTopBannersSchema.json')
    * assert JavaFunctions.isValid(jsonResponse,JSONSchemaExpected)

  @MobileApiTest @GetMainHomepageTopBannersCustomLimit @Regression @Sanity @Smoke @Mobile @GET
  Scenario: API for Main Homepage Top Banners (v2) with custom limit

    * def parameters = paramsTo.MainHomePageCustomLimitParams
    Given path pathsTo.MobileAPI.MainHomePageTopBanners
    And params parameters
    And headers headersToBeUsed
    When method GET
    Then status 200
    And match response.status_code == 200
    And match response.message == "Success"
    And match response.meta_data.from == 0
    And match response.meta_data.limit == 2

  @MobileApiTest @GetMainHomepageTopBannersWithoutParams @Regression @Sanity @Smoke @Mobile @GET
  Scenario: API for Main Homepage Top Banners (v2) without parameters

    Given path pathsTo.MobileAPI.MainHomePageTopBanners
    And headers headersToBeUsed
    When method GET
    Then status 200
    And match response.status_code == 200
    And match response.message == "Success"

  @MobileApiTest @GetMainHomepageTopBannersWithoutAuth @Regression @Sanity @Smoke @Mobile @GET
  Scenario: API for Main Homepage Top Banners (v2) without Authorization

    * headersToBeUsed["Authorization"] = ''
    * def parameters = paramsTo.MainHomePageTopBannersParams
    Given path pathsTo.MobileAPI.MainHomePageTopBanners
    And params parameters
    And headers headersToBeUsed
    When method GET
    Then status 403
    And match response.status_code == 403
    And match response.message == "A token is required for authentication"

  @MobileApiTest @GetMainHomepageTopBannersCustomParams @Regression @Sanity @Smoke @Mobile @GET
  Scenario: API for Main Homepage Top Banners (v2) with custom/invalid parameters

    * def parameters = paramsTo.MainHomePageTopBannersCustomParams
    Given path pathsTo.MobileAPI.MainHomePageTopBanners
    And params parameters
    And headers headersToBeUsed
    When method GET
    Then status 200
    And match response.status_code == 200
    And match response.message == "Success"





