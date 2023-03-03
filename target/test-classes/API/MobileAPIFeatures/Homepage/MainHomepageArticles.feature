@MainHomepage @Articles

Feature: Main Homepage V2 Articles API
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

  @MobileApiTest @GetMainHomepageArticles @Regression @Sanity @Smoke @Mobile @GET
  Scenario: API for Main Homepage Articles (v2)

    * def parameters = paramsTo.ArticleHomePageParams
    Given path pathsTo.MobileAPI.Articles
    And params parameters
    And headers headersToBeUsed
    When method GET
    Then status 200
    And match response.status_code == 200
    And match response.message == "Success"
    And match response.meta_data.from == 0
    And match response.meta_data.limit == 10
    And match each $..id != ''
    And match each $..title != ''
    And match each $..description != ''
    And match each $..name != ''
    And match each $..image != ''
    And match each $..portrait_cover_image != ''
    And match each $..landscape_cover_image != ''
    And match each $..child_category != ''
    * def FirstArticleId = response.data.records[0].id
    * def error_msgs = response.error_msgs
    And assert error_msgs.length == 0
    * string jsonResponse = response
    * string JSONSchemaExpected = read('../../schemas/mainHomepageArticles.json')
    * assert JavaFunctions.isValid(jsonResponse,JSONSchemaExpected)

  @MobileApiTest @GetMainHomepageArticlesDetails @Regression @Sanity @Smoke @Mobile @GET
  Scenario: API for Main Homepage Article Details (v2)

    * def featureToBeUsed = read('@GetMainHomepageArticles')
    * def result = call featureToBeUsed
    * def parameters = paramsTo.ArticleDetailsParams
    * parameters["article_id"] = result.FirstArticleId
    Given path pathsTo.MobileAPI.ArticlesDetails
    And params parameters
    And headers headersToBeUsed
    When method GET
    Then status 200
    And match response.status_code == 200
    And match response.message == "Success"
    And match each $..article_id != ''
    And match each $..id != ''
    And match each $..title != ''
    And match each $..description != ''
    And match each $..image != ''
    And match each $..author_image != ''
    And match each $..author_text != ''
    And match each $..parent_category != ''
    And match each $..child_category != ''
    And match each $..element_type != ''
    And match each $..media_url != ''
    And match each $..thumbnail_url == '#string'
    And match each $..portrait_cover_image != ''
    And match each $..landscape_cover_image != ''
    And match each $..child_category != ''
    * def error_msgs = response.error_msgs
    And assert error_msgs.length == 0
    * string jsonResponse = response
    * string JSONSchemaExpected = read('../../schemas/articleDetail.json')
    * assert JavaFunctions.isValid(jsonResponse,JSONSchemaExpected)

  @MobileApiTest @GetMainHomepageArticlesIncorrectParams @Regression @Sanity @Smoke @Mobile @GET
  Scenario: API for Main Homepage Articles (v2)

    * def parameters = paramsTo.ArticleHomePageIncorrectParams
    Given path pathsTo.MobileAPI.Articles
    And params parameters
    And headers headersToBeUsed
    When method GET
    Then status 422
    And match response.status_code == 422
    And match response.message == "Internal server error!"


