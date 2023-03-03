@Auth
Feature: Register User
  Background: Background variables
    * url startingURL+'sharedservice'+endingUrl
   # * url 'https://vwdf4zbj02.execute-api.us-east-1.amazonaws.com/optimization'
    * def JavaData = Java.type('com.veritec.automation.JavaFunctionsAPI.DataReader.EnvConfig')
    * def Object = new JavaData()
    * def JavaFunctions = Java.type('com.veritec.automation.JavaFunctionsAPI.ReusableFunctions')
    * def ObjectFunc = new JavaFunctions()
    * def payloadsData = read('../../payloads/devDataAPI.json')
    * def pathsTo = read('../../support/paths.json')
    * def paramsTo = read('../../support/params.json')
    * def headersTo = read('../../support/headers.json')


  @MobileApiTest @UserRegistrationWithKey @Prod_Exclusion @Regression @Sanity @Smoke @Mobile @POST
  Scenario: API for registration of a user
    * def CreateAccountPayload = payloadsData.CreateAccount.ValidDetails
    * CreateAccountPayload["email"] = Object.configFinalRandomEmail
    * CreateAccountPayload["username"] = Object.configUserName
    * CreateAccountPayload["password"] = Object.configRandomPassword
    * CreateAccountPayload["secret"] = Object.getSecretToken()
    Given path pathsTo.MobileAPI.Registration
    And request CreateAccountPayload
    When method POST
    Then status 200
    And if (response.status_code != 200) karate.fail("status not equal to 200")
    And match response.status_code == 200
    # To check the response message
    And match response.message == "Account created successfully"
    # To check the data type of response
    And match response.message == '#string'
    # To check contains
    And match response.message contains "Account"

  @MobileApiTest @UserRegistrationWithKeyEmptyEmail @Prod_Exclusion @Regression @Sanity @Smoke @Mobile @POST @Negative
  Scenario: API for registration of a user with empty email
    * def CreateAccountPayload = payloadsData.CreateAccount.ValidDetails
    * CreateAccountPayload["username"] = Object.configUserName
    * CreateAccountPayload["password"] = Object.configRandomPassword
    * CreateAccountPayload["secret"] = Object.getSecretToken()
    Given path pathsTo.MobileAPI.Registration
    And request CreateAccountPayload
    When method POST
    Then status 200
    And match response.status_code == 500
    # To check the response message
    And match response.message == "Validation errors"


  @MobileApiTest @RegisteredUserLogin @Prod_Exclusion @Regression @Sanity @Smoke @Mobile @POST
  Scenario: Login User after new registration

    * def featureToBeUsed = read('@UserRegistrationWithKey')
    * def result = call featureToBeUsed
    * def RegisteredUserLoginPayload = payloadsData.LoginCredentials.RegisteredUser_Login
    * RegisteredUserLoginPayload["email"] = Object.configFinalRandomEmail
    * RegisteredUserLoginPayload["password"] = Object.configRandomPassword
    Given path pathsTo.MobileAPI.Login
    And request RegisteredUserLoginPayload
    When method POST
    Then status 200
    And match response.status_code == 200
    And match response.message == "User logged in successfully "
    And match response.data.user.access_token != null
    * def accessToken = "Bearer "+response.data.user.access_token

  @MobileApiTest @DemoUserRegistration @Prod_Exclusion @Regression @Sanity @Smoke @Mobile @POST
  Scenario: API for registration of a Demo user
    * def CreateDemoAccountPayload = payloadsData.CreateAccount.DemoUser
    Given path pathsTo.MobileAPI.DemoUserRegistration
    And request CreateDemoAccountPayload
    When method POST
    Then status 200
    And match response.status_code == 200
    # To check the response message
    And match response.message == "Demo account created successfully"
    * def demoUserToken = response.data.user.refresh_token

  @MobileApiTest @DemoUserRegistrationWithout @Prod_Exclusion @Regression @Sanity @Smoke @Mobile @POST @Negative
  Scenario: API for registration of a Demo user
    * def CreateDemoAccountPayload = payloadsData.CreateAccount.DemoUser
    Given path pathsTo.MobileAPI.DemoUserRegistration
    And request CreateDemoAccountPayload
    When method POST
    Then status 200
    And match response.status_code == 200
    # To check the response message
    And match response.message == "Demo account created successfully"
    * def demoUserToken = response.data.user.refresh_token

  @MobileApiTest @AutoLogin @Prod_Exclusion @Regression @Sanity @Smoke @Mobile @POST
  Scenario: API for Auto Login
    * def featureToBeUsed = read('Authentication.feature@DemoUserRegistration')
    * def result = call featureToBeUsed
    * def AutoLoginPayload = payloadsData.CreateAccount.AutoLogin
    * AutoLoginPayload["token"] = result.demoUserToken
    Given path pathsTo.MobileAPI.AutoLogin
    And request AutoLoginPayload
    When method POST
    Then status 200
    And match response.status_code == 200
    # To check the response message
    And match response.message == "User login successfully"

  @MobileApiTest @EmailAvailable @Prod_Exclusion @Regression @Sanity @Smoke @Mobile @POST
  Scenario: API for Email Availability
    * def EmailAvailablePayload = payloadsData.CreateAccount.EmailAvailable
    Given path pathsTo.MobileAPI.EmailAvailable
    And request EmailAvailablePayload
    When method POST
    Then status 200
    And match response.status_code == 200
    # To check the response message
    And match response.message == "Email available"

  @MobileApiTest @EmailUnAvailable @Prod_Exclusion @Regression @Sanity @Smoke @Mobile @POST @Negative
  Scenario: API for Email Availability Negative Case
    * def EmailUnAvailablePayload = payloadsData.CreateAccount.EmailAlreadyExist
    Given path pathsTo.MobileAPI.EmailAvailable
    And request EmailUnAvailablePayload
    When method POST
    Then status 200
    And match response.status_code == 403
    # To check the response message
    And match response.message contains "already exists"

  @MobileApiTest @VerifyUserName @Prod_Exclusion @Regression @Sanity @Smoke @Mobile @POST
  Scenario: API for Verify UserName Availability
    * def VerifyUserNamePayload = payloadsData.CreateAccount.VerifyUserName
    Given path pathsTo.MobileAPI.VerifyUserName
    And request VerifyUserNamePayload
    When method POST
    Then status 200
    And match response.status_code == 200
    # To check the response message
    And match response.message == "Username available"

  @MobileApiTest @VerifyUserNameUnavailable @Prod_Exclusion @Regression @Sanity @Smoke @Mobile @POST @Negative
  Scenario: API for Verify UserName UnAvailability
    * def VerifyUserNamePayload = payloadsData.CreateAccount.VerifyUserNameUnavailable
    Given path pathsTo.MobileAPI.VerifyUserName
    And request VerifyUserNamePayload
    When method POST
    Then status 200
    And match response.status_code == 403
    # To check the response message
    And match response.message contains "already exists"

  @MobileApiTest @RegisterUserWithoutKey @Prod_Exclusion @Regression @Sanity @Smoke @Mobile @POST
  Scenario: API for registration of a user Without Key
    * def CreateAccountPayload = payloadsData.CreateAccount.ValidDetails
    * def randomUserName = "Auto"+ JavaFunctions.getTime()
    * def emailToBeUsed = randomUserName + "@yopmail.com"
    * CreateAccountPayload["email"] = emailToBeUsed
    * CreateAccountPayload["username"] = randomUserName
    * CreateAccountPayload["password"] = Object.configRandomPassword
    * CreateAccountPayload["test_user"] = false
    Given path pathsTo.MobileAPI.Registration
    And request CreateAccountPayload
    When method POST
    Then status 200
    And match response.status_code == 200
    # To check the response message
    And match response.message == "Account created successfully"
    # To check the data type of response
    And match response.message == '#string'
    # To check contains
    And match response.message contains "Account"

  @MobileApiTest @GetEmailVerificationCode @Prod_Exclusion @Regression @Sanity @Smoke @Mobile @GET
  Scenario: API for Getting Email Verification Code
    * def featureToBeUsed = read('Authentication.feature@RegisterUserWithoutKey')
    * def result = call featureToBeUsed
    * def VerificationCodeParams = paramsTo.VerificationCodeParams
    * VerificationCodeParams["email"] = result.emailToBeUsed
    Given path pathsTo.MobileAPI.VerificationCode
    And params VerificationCodeParams
    And headers headersTo.CommonHeaders
    When method GET
    Then status 200
    And match response.status_code == 200
    # To check the response message
    And match response.message == "Verification Codes"
    * def verificationCodeForEmail = response.data.email_verification_token

  @MobileApiTest @GetEmailVerificationCodeForEmailNotExist @Prod_Exclusion @Regression @Sanity @Smoke @Mobile @GET @Negative
  Scenario: API for Getting Email Verification Code For Email Not exist
    * def randomUserName = "Auto"+JavaFunctions.getTime()
    * def emailToBeUsed = randomUserName + "@yopmail.com"
    * def VerificationCodeParams = paramsTo.VerificationCodeParams
    * VerificationCodeParams["email"] = emailToBeUsed
    Given path pathsTo.MobileAPI.VerificationCode
    And params VerificationCodeParams
    And headers headersTo.CommonHeaders
    When method GET
    Then status 200
    And match response.status_code == 500
    # To check the response message
    And match response.message == "User not found"


  @MobileApiTest @VerifyEmail @Prod_Exclusion @Regression @Sanity @Smoke @Mobile @POST
  Scenario: API for Email Verification
    * def featureToBeUsed = read('Authentication.feature@GetEmailVerificationCode')
    * def result = call featureToBeUsed
    * def VerifyEmailPayload = payloadsData.CreateAccount.VerifyEmail
    * VerifyEmailPayload["email_verification_token"] = result.verificationCodeForEmail
    Given path pathsTo.MobileAPI.VerifyEmail
    And headers headersTo.CommonHeaders
    And request VerifyEmailPayload
    When method POST
    Then status 200
    And match response.status_code == 200
    # To check the response message
    And match response.message == "Email verified successfully"

  @MobileApiTest @VerifyEmailWithWrongVerificationToken @Prod_Exclusion @Regression @Sanity @Smoke @Mobile @POST @Negative
  Scenario: API for Email Verification
    * def VerifyEmailPayload = payloadsData.CreateAccount.VerifyEmail
    * VerifyEmailPayload["email_verification_token"] = "abcdEF"
    Given path pathsTo.MobileAPI.VerifyEmail
    And headers headersTo.CommonHeaders
    And request VerifyEmailPayload
    When method POST
    Then status 200
    And match response.status_code == 403
    # To check the response message
    And match response.message == "Invalid email verification token"

  @MobileApiTest @RequestPassword @Prod_Exclusion @Regression @Sanity @Smoke @Mobile @POST
  Scenario: API for Request Password
    * def RequestPasswordPayload = payloadsData.CreateAccount.RequestPassword
    Given path pathsTo.MobileAPI.RequestPassword
    And headers headersTo.CommonHeaders
    And request RequestPasswordPayload
    When method POST
    Then status 200
    And match response.status_code == 200
    # To check the response message
    And match response.message == "Email sent"

  @MobileApiTest @RequestPasswordForEmailNotExist @Prod_Exclusion @Regression @Sanity @Smoke @Mobile @POST @Negative
  Scenario: API for Request Password
    * def RequestPasswordPayload = payloadsData.CreateAccount.EmailUnavailable
    Given path pathsTo.MobileAPI.RequestPassword
    And headers headersTo.CommonHeaders
    And request RequestPasswordPayload
    When method POST
    Then status 200
    And match response.status_code == 404
    # To check the response message
    And match response.message == "User not found"

  @MobileApiTest @GetPasswordVerificationCode @Prod_Exclusion @Regression @Sanity @Smoke @Mobile @GET
  Scenario: API for Getting Password Verification Code
    * def featureToBeUsed = read('Authentication.feature@RequestPassword')
    * def result = call featureToBeUsed
    * def PasswordVerificationCodeParams = paramsTo.PasswordVerificationCodeParams
    Given path pathsTo.MobileAPI.VerificationCode
    And params PasswordVerificationCodeParams
    And headers headersTo.CommonHeaders
    When method GET
    Then status 200
    And match response.status_code == 200
    # To check the response message
    And match response.message == "Verification Codes"
    * def verificationCodeForPassword = response.data.password_reset_token

  @MobileApiTest @ResetPassword @Prod_Exclusion @Regression @Sanity @Smoke @Mobile @POST
  Scenario: API for Password Reset
    * def featureToBeUsed = read('Authentication.feature@GetPasswordVerificationCode')
    * def result = call featureToBeUsed
    * def ResetPasswordPayload = payloadsData.CreateAccount.ResetPassword
    * ResetPasswordPayload["password_reset_token"] = result.verificationCodeForPassword
    Given path pathsTo.MobileAPI.ResetPassword
    And headers headersTo.CommonHeaders
    And request ResetPasswordPayload
    When method POST
    Then status 200
    And match response.status_code == 200
    # To check the response message
    And match response.message == "New password created successfully "

  @MobileApiTest @ResetPasswordWithWrongVerificationCode @Prod_Exclusion @Regression @Sanity @Smoke @Mobile @POST @Negative
  Scenario: API for Password Reset
    * def ResetPasswordPayload = payloadsData.CreateAccount.ResetPassword
    * ResetPasswordPayload["password_reset_token"] = "abcdEFG"
    Given path pathsTo.MobileAPI.ResetPassword
    And headers headersTo.CommonHeaders
    And request ResetPasswordPayload
    When method POST
    Then status 200
    And match response.status_code == 404
    # To check the response message
    And match response.message == "One Time Password (OTP) is invalid"

  @MobileApiTest @RegisterUserWithSocial @Prod_Exclusion @Regression @Sanity @Smoke @Mobile @POST
  Scenario: API for registration of a user with social account
    * def CreateAccountPayload = payloadsData.CreateAccount.ValidDetails
    * def randomUserName = "Auto"+JavaFunctions.getTime()
    * def emailToBeUsed = randomUserName + "@yopmail.com"
    * CreateAccountPayload["email"] = emailToBeUsed
    * CreateAccountPayload["username"] = randomUserName
    * CreateAccountPayload["password"] = Object.configRandomPassword
    * CreateAccountPayload["test_user"] = false
    Given path pathsTo.MobileAPI.SocialRegistration
    And request CreateAccountPayload
    When method POST
    Then status 200
    And match response.status_code == 200
    # To check the response message
    And match response.message == "User created successfully"

  @MobileApiTest @RegisterUserWithSocialEmptyEmail @Prod_Exclusion @Regression @Sanity @Smoke @Mobile @POST @Negative
  Scenario: API for registration of a user with social account empty email
    * def CreateAccountPayload = payloadsData.CreateAccount.ValidDetails
    * CreateAccountPayload["username"] = Object.configRandomUserName
    * CreateAccountPayload["password"] = Object.configRandomPassword
    * CreateAccountPayload["test_user"] = false
    Given path pathsTo.MobileAPI.SocialRegistration
    And request CreateAccountPayload
    When method POST
    Then status 200
    And match response.status_code == 500
    # To check the response message
    And match response.message == "Validation errors"
