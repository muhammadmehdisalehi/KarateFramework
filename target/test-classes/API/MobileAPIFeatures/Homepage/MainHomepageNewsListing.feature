@MainHomepage @News

Feature: Main Homepage News v2 API
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

  @MobileApiTest @GetMainHomepageNews @Regression @Sanity @Smoke @Mobile @GET
  Scenario: API for Main Homepage News (v2)

    * def parameters = paramsTo.NewsHomePageParams
    Given path pathsTo.MobileAPI.News
    And params parameters
    And headers headersToBeUsed
    When method GET
    Then status 200
    And match response.status_code == 200
    And match response.message == "Success"
    And match response.meta_data.from == 0
    And match response.meta_data.limit == 5
    * def NewsIds = $response.data.records[*].id
    * def LastNewsId = response.data.records[4].id
    And match each $..id != ''
    And match each $..data.records.title != ''
    And match each $..data.records.description != ''
    And match each $..data.records.name != ''
    And match each $..image != ''
    * def error_msgs = response.error_msgs
    And assert error_msgs.length == 0
    * assert NewsIds.length == 5
    * string jsonResponse = response
    * string JSONSchemaExpected = read('../../schemas/MainHomepageNewsListing.json')
    * assert JavaFunctions.isValid(jsonResponse,JSONSchemaExpected)

  @MobileApiTest @GetMainHomepageNewsSeeAll @Regression @Sanity @Smoke @Mobile @GET
  Scenario: API for Main Homepage News see All News(v2)

    * def parameters = paramsTo.NewsHomePageParams
    * parameters["limit"] = 6
    Given path pathsTo.MobileAPI.News
    And params parameters
    And headers headersToBeUsed
    When method GET
    Then status 200
    And match response.status_code == 200
    And match response.message == "Success"
    And match response.meta_data.from == 0
    And match response.meta_data.limit == 6
    And match each $..id != ''
    And match each $..data.records.title != ''
    And match each $..data.records.description != ''
    And match each $..data.records.name != ''
    And match each $..image != ''
    * def error_msgs = response.error_msgs
    And assert error_msgs.length == 0
    * def NewsIds = $response.data.records[*].id
    * assert NewsIds.length == 6
    * string jsonResponse = response
    * string JSONSchemaExpected = read('../../schemas/MainHomepageNewsListing.json')
    * assert JavaFunctions.isValid(jsonResponse,JSONSchemaExpected)

  @MobileApiTest @GetMainHomepageNewsWrongParams @Regression @Sanity @Smoke @Mobile @GET @Negative
  Scenario: API for Main Homepage News (v2) Wrong Params

    * def parameters = paramsTo.NewsHomePageIncorrectParams
    Given path pathsTo.MobileAPI.News
    And params parameters
    And headers headersToBeUsed
    When method GET
    Then status 422
    And match response.status_code == 422
    And match response.message == "Internal server error!"



  @MobileApiTest @GetNewsFromHomePageWithID @Regression @Sanity @Smoke @Mobile @GET
  Scenario: Get news with ID from Homepage (v2) with ID

    * def featureToBeUsed = read('@GetMainHomepageNews')
    * def result = call featureToBeUsed
    * def parameters = paramsTo.NewsListingParams
    * parameters["news_id"] = result.LastNewsId
    Given path pathsTo.MobileAPI.News
    And params parameters
    And headers headersToBeUsed
    When method GET
    Then status 200
    And match response.status_code == 200
    And match response.message == "Success"
    And match response.meta_data.from == 0
    And match response.meta_data.limit == 5
    And match response.data.records[0].id == result.LastNewsId
    And match response.data.records[1].id == result.NewsIds[0]
    And match response.data.records[2].id == result.NewsIds[1]
    And match response.data.records[3].id == result.NewsIds[2]
    And match response.data.records[4].id == result.NewsIds[3]
    And match each $..id != ''
    And match each $..data.records.title != ''
    And match each $..data.records.description != ''
    And match each $..data.records.name != ''
    And match each $..image != ''
    * def error_msgs = response.error_msgs
    And assert error_msgs.length == 0
    And print result.NewsIds
    * def NewsIds = $response.data.records[*].id
    * assert NewsIds.length == 5
    * string jsonResponse = response
    * string JSONSchemaExpected = read('../../schemas/MainHomepageNewsListing.json')
    * assert JavaFunctions.isValid(jsonResponse,JSONSchemaExpected)

