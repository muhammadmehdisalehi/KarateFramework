@UserLogin
Feature: Login User
  Background: Background variables
    * url startingURL
    * def JavaData = Java.type('com.veritec.automation.JavaFunctionsAPI.DataReader.EnvConfig')
    * def payloadsData = read('../../payloads/devDataAPI.json')
    * def pathsTo = read('../../support/paths.json')

   @ValidUserLogin
  Scenario: Login User
    * def RegisteredUserLoginPayload = payloadsData.LoginCredentials.RegisteredUser_Login
    * RegisteredUserLoginPayload["email_address"] = 'mehdi.salehi@cloudprimero.com'
    * RegisteredUserLoginPayload["password"] = 'Admin123!'
    Given path pathsTo.MobileAPI.Login
    And request RegisteredUserLoginPayload
    When method POST
    Then status 200
    And match response.message == "User Login Successfully"
    And match response.data != []
     And response.success != false
    * def accessToken = "Bearer "+response.token
