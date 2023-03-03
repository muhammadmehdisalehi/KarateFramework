@MainHomepage @Questions

Feature: Main Homepage V2 Articles API
  Background: Background Variables
    * url startingURL+'homemedia'+endingUrl
    * def JavaData = Java.type('com.jogo.automation.JavaFunctionsAPI.DataReader.EnvConfig')
    * def Object = new JavaData()
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

  @MobileApiTest @GetMainHomeQuestions @Regression @Sanity @Smoke @Mobile @GET
  Scenario: API for Get Questions on Homepage (v2)

    Given path pathsTo.MobileAPI.Questions
    And headers headersToBeUsed
    When method GET
    Then status 200
    And match response.status_code == 200
    And match response.message == "Success"
    * def error_msgs = response.error_msgs
    And assert error_msgs.length == 0
    And if (response.data.total_records == 0) karate.fail("total records = 0")
    And match response.data.total_records != 0
    And match each $..id != ''
    And match each $..meta_id != ''
    And match each $..results_title != ''
    And match each $..results_image != ''
    And match each $..positive_results_title != ''
    And match each $..positive_results_image != ''
    And match each $..negative_results_title != ''
    And match each $..negative_results_image != ''
    And match each $..question != ''
    And match $..question_type contains any [poll,quiz]
    And match each $..image != ''
    And match each $..answer !=''
    * string jsonResponse = response
    * string JSONSchemaExpected = read('../../schemas/mainHomepageQuestions.json')
    * assert JavaFunctions.isValid(jsonResponse,JSONSchemaExpected)

  @MobileApiTest @GetMainHomeQuestionsPoll @Regression @Sanity @Smoke @Mobile @GET
  Scenario: API for Get Poll Questions on Homepage (v2)

    Given path pathsTo.MobileAPI.Questions
    And headers headersToBeUsed
    When method GET
    Then status 200
    And match response.status_code == 200
    And match response.message == "Success"
    * def error_msgs = response.error_msgs
    And assert error_msgs.length == 0
    And if (response.data.total_records == 0) karate.fail("total records = 0")
    And match response.data.total_records != 0
    And match each $..id != ''
    And match each $..meta_id != ''
    And match $..question_type contains any [poll,quiz]
    And match each $..image != ''
    And match each $..answer !=''
    * def Poll_ids = $..[?(@.question_type=='poll')].id
    And if (response.data.total_polls == 0) karate.fail("total records = 0")
    And match response.data.total_polls != 0
    * def Poll_Answer_Type = $..[?(@.question_type=='poll')]answers..answer_type
    And print Poll_Answer_Type
    And match each Poll_Answer_Type == 'poll'
    * string jsonResponse = response
    * string JSONSchemaExpected = read('../../schemas/mainHomepageQuestions.json')
    * assert JavaFunctions.isValid(jsonResponse,JSONSchemaExpected)

  @MobileApiTest @GetMainHomeQuestionsQuiz @Regression @Sanity @Smoke @Mobile @GET
  Scenario: API for Get Quiz Questions on Homepage (v2)

    Given path pathsTo.MobileAPI.Questions
    And headers headersToBeUsed
    When method GET
    Then status 200
    And match response.status_code == 200
    And match response.message == "Success"
    * def error_msgs = response.error_msgs
    And assert error_msgs.length == 0
    And if (response.data.total_records == 0) karate.fail("total records = 0")
    And match response.data.total_records != 0
    And match each $..id != ''
    And match each $..meta_id != ''
    And match each $..positive_results_title != ''
    And match each $..positive_results_image != ''
    And match each $..negative_results_title != ''
    And match each $..negative_results_image != ''
    And match each $..question != ''
    And match $..question_type contains any [poll,quiz]
    And match each $..image != ''
    And match each $..answer !=''
    * def Quiz_ids = $..[?(@.question_type=='quiz')].id
    And if (Quiz_ids.length == 0) karate.fail("total Quiz ids = 0")
    And match response.data.total_quizzes != 0
    * def Quiz_Answer_Type = $..[?(@.question_type=='quiz')]answers..answer_type
    And match each $..Quiz_Answer_Type contains any [right_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3]
    * def Quiz_Answer_Position = karate.jsonPath(response, "$..[?(@.answer_type=='right_answer')].position")
    And print Quiz_Answer_Position
    * def result = 0
    * def fun = function(x){ var temp = karate.get('result'); karate.set('result', temp + x )}
    * karate.forEach(Quiz_Answer_Position, fun)
    And if  (Quiz_Answer_Position.length > 1) karate.match("result != 0")
    * string jsonResponse = response
    * string JSONSchemaExpected = read('../../schemas/mainHomepageQuestions.json')
    * assert JavaFunctions.isValid(jsonResponse,JSONSchemaExpected)


  @MobileApiTest @PostMainHomeAnswerQuestionsPOLL @Regression @Sanity @Smoke @Mobile @POST
  Scenario: API for Post Poll Answers Questions on Homepage (v2)
    * def featureToBeUsed = read('../Login/Authentication.feature@RegisteredUserLogin')
    * def result = call featureToBeUsed
    * headersToBeUsed["Authorization"] = result.accessToken
    * def featureToBeUsed = read('@GetMainHomeQuestionsPoll')
    * def result = call featureToBeUsed
    * def parameters = paramsTo.AnswerQuestionParams
    * def FirstPoll_ids =  result.Poll_ids[0]
    * def Poll_Answer_id = karate.jsonPath(result, "$..[?(@.id=='" + FirstPoll_ids + "')]answers..id")[0]
    * def Poll_Total_Participants = karate.jsonPath(result, "$..[?(@.id=='" + FirstPoll_ids + "')]..total_question_participants")[0]
    * def Poll_Total_Answer_Participants = karate.jsonPath(result, "$..[?(@.id=='" + Poll_Answer_id + "')].total_answer_participants")
    * parameters["question_id"] = FirstPoll_ids
    * parameters["answer_id"] = Poll_Answer_id
    Given path pathsTo.MobileAPI.AnswerQuestions
    And params parameters
    And headers headersToBeUsed
    When method GET
    Then status 200
    And match response.status_code == 200
    And match response.message == "Success"
    * def error_msgs = response.error_msgs
    And assert error_msgs.length == 0
    And match response.data.answers[0].my_answer.question_id == FirstPoll_ids
    And match response.data.answers[0].my_answer.answer_id == Poll_Answer_id
    * def participants = response.data.total_question_participants
    * def Answer_participants = response.data.answers[0].total_answer_participants
    And match Answer_participants == parseInt(Poll_Total_Answer_Participants[0] + 1)
    And match participants == Poll_Total_Participants + 1
    * def featureToBeUsed = read('@GetMainHomeQuestionsPoll')
    * def result = call featureToBeUsed
    * def FirstPoll_ids =  result.Poll_ids[0]
    * def Poll_Answer_id = karate.jsonPath(result, "$..[?(@.id=='" + FirstPoll_ids + "')]answers..id")[0]
    * def Poll_Total_Participants = karate.jsonPath(result, "$..[?(@.id=='" + FirstPoll_ids + "')]..total_question_participants")[0]
    * def Poll_Total_Answer_Participants = karate.jsonPath(result, "$..[?(@.id=='" + Poll_Answer_id + "')].total_answer_participants")
    And match Poll_Total_Participants == participants
    And match parseInt(Poll_Total_Answer_Participants) == Answer_participants
    * string jsonResponse = response
    * string JSONSchemaExpected = read('../../schemas/QuestionAnswerResponse.json')
    * assert JavaFunctions.isValid(jsonResponse,JSONSchemaExpected)

  @MobileApiTest @PostMainHomeAnswerQuestionsQUIZ @Regression @Sanity @Smoke @Mobile @POST
  Scenario: API for Post Quiz Answers Questions on Homepage (v2)
    * def featureToBeUsed = read('../Login/Authentication.feature@RegisteredUserLogin')
    * def result = call featureToBeUsed
    * headersToBeUsed["Authorization"] = result.accessToken
    * def featureToBeUsed = read('@GetMainHomeQuestionsQuiz')
    * def result = call featureToBeUsed
    * def parameters = paramsTo.AnswerQuestionParams
    * def FirstQuiz_ids =  result.Quiz_ids[0]
    * def Quiz_Answer_id = karate.jsonPath(result, "$..[?(@.id=='" + FirstQuiz_ids + "')]answers..id")[0]
    * def Quiz_Total_Participants = karate.jsonPath(result, "$..[?(@.id=='" + FirstQuiz_ids + "')]..total_question_participants")[0]
    * def Quiz_Total_Answer_Participants = karate.jsonPath(result, "$..[?(@.id=='" + Quiz_Answer_id + "')].total_answer_participants")
    And print Quiz_Total_Answer_Participants
    * parameters["question_id"] = FirstQuiz_ids
    * parameters["answer_id"] = Quiz_Answer_id
    Given path pathsTo.MobileAPI.AnswerQuestions
    And params parameters
    And headers headersToBeUsed
    When method GET
    Then status 200
    And match response.status_code == 200
    And match response.message == "Success"
    * def error_msgs = response.error_msgs
    And assert error_msgs.length == 0
    And match response.data.answers[0].my_answer.question_id == FirstQuiz_ids
    And match response.data.answers[0].my_answer.answer_id == Quiz_Answer_id
    * def participants = response.data.total_question_participants
    * def Answer_participants = response.data.answers[0].total_answer_participants
    And match Answer_participants == parseInt(Quiz_Total_Answer_Participants[0] + 1)
    And match participants == Quiz_Total_Participants + 1
    * def featureToBeUsed = read('@GetMainHomeQuestionsQuiz')
    * def result = call featureToBeUsed
    * def FirstQuiz_ids =  result.Quiz_ids[0]
    * def Quiz_Answer_id = karate.jsonPath(result, "$..[?(@.id=='" + FirstQuiz_ids + "')]answers..id")[0]
    * def Quiz_Total_Participants = karate.jsonPath(result, "$..[?(@.id=='" + FirstQuiz_ids + "')]..total_question_participants")[0]
    * def Quiz_Total_Answer_Participants = karate.jsonPath(result, "$..[?(@.id=='" + Quiz_Answer_id + "')].total_answer_participants")
    And match Quiz_Total_Participants == participants
    And match parseInt(Quiz_Total_Answer_Participants) == Answer_participants
    * string jsonResponse = response
    * string JSONSchemaExpected = read('../../schemas/QuestionAnswerResponse.json')
    * assert JavaFunctions.isValid(jsonResponse,JSONSchemaExpected)


  @MobileApiTest @PostMainHomeAnswerQuestionsSameUser @Regression @Sanity @Smoke @Mobile @POST @Negative
  Scenario: API for Post Poll Answers Questions from same user on Homepage (v2)
    * def featureToBeUsed = read('../Login/Authentication.feature@RegisteredUserLogin')
    * def result = call featureToBeUsed
    * headersToBeUsed["Authorization"] = result.accessToken
    * def featureToBeUsed = read('@GetMainHomeQuestionsPoll')
    * def result = call featureToBeUsed
    * def Participant_after_answer = result.Quiz_Total_Participants
    * def parameters = paramsTo.AnswerQuestionParams
    * def FirstPoll_ids =  result.Poll_ids[0]
    * def Poll_Answer_id = karate.jsonPath(result, "$..[?(@.id=='" + FirstPoll_ids + "')]answers..id")[0]
    * parameters["question_id"] = FirstPoll_ids
    * parameters["answer_id"] = Poll_Answer_id
    Given path pathsTo.MobileAPI.AnswerQuestions
    And params parameters
    And headers headersToBeUsed
    When method GET
    Then status 200
    And match response.status_code == 200
    And match response.message == "Success"
    * def error_msgs = response.error_msgs
    And assert error_msgs.length == 0

    Given path pathsTo.MobileAPI.AnswerQuestions
    And params parameters
    And headers headersToBeUsed
    When method GET
    Then status 409
    And match response.status_code == 409
    And match response.message == "Invalid Parameters"

  @MobileApiTest @VerifyQuizAnswerPositions @Regression @Sanity @Smoke @Mobile @GET
  Scenario: Verify Quiz Answer Positions

    Given path pathsTo.MobileAPI.Questions
    And headers headersToBeUsed
    When method GET
    Then status 200
    And match response.status_code == 200
    And match response.message == "Success"
    * def error_msgs = response.error_msgs
    And assert error_msgs.length == 0
    And match response.data.total_records != 0
    And match $..question_type contains any [poll,quiz]
    * def Quiz_ids = $..[?(@.question_type=='quiz')].id
    And if (Quiz_ids.length == 0) karate.fail("total Quizrecords = 0")
    * def FirstQuiz_ids =  Quiz_ids[0]
    * def Quiz_Answer_Type = $..[?(@.question_type=='quiz')]answers..answer_type
    * def Quiz_Answer_id = karate.jsonPath(response, "$..[?(@.id=='" + FirstQuiz_ids + "')]answers..id")[0]
    * def Quiz_Answer_Position = karate.jsonPath(response, "$..[?(@.answer_type=='right_answer')].position")
    * def result = 0
    * def fun = function(x){ var temp = karate.get('result'); karate.set('result', temp + x )}
    * karate.forEach(Quiz_Answer_Position, fun)
    And print result
    And print  Quiz_Answer_Position.length
    * if  (Quiz_Answer_Position.length > 1) karate.match("result != 0")
    And match each $..Quiz_Answer_Type contains any [right_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3]
    * string jsonResponse = response
    * string JSONSchemaExpected = read('../../schemas/mainHomepageQuestions.json')
    * assert JavaFunctions.isValid(jsonResponse,JSONSchemaExpected)


  @MobileApiTest @PostMainHomeAnswerAllQuestions @Regression @Sanity @Smoke @Mobile @POST
  Scenario: API for Post Answers All Questions on Homepage (v2)
    * def featureToBeUsed = read('../Login/Authentication.feature@RegisteredUserLogin')
    * def result = call featureToBeUsed
    * headersToBeUsed["Authorization"] = result.accessToken
    * def featureToBeUsed = read('@GetMainHomeQuestionsQuiz')
    * def result = call featureToBeUsed
    * def response = result.response
    * def Question_id = karate.jsonPath(response, "$.data.records[*].id")
    * def Answer_id = karate.jsonPath(response, "$.data.records[*].answers[0].id")
    And print Question_id
    And print Answer_id
    * def fun = function(x, i){ var pair = {}; pair[x] = Answer_id[i]; return pair }
    * def pairs = karate.map(Question_id, fun)
    * def data = karate.mapWithKey(pairs, 'QuestionAnswerIDToGet')
    * def featureToBeUsed = read('@PostMainHomeAnswerQuestions')
    * def result = callonce featureToBeUsed data


  @PostMainHomeAnswerQuestions @ignore
  Scenario:
    * def items = QuestionAnswerIDToGet
    * def QuestionID = karate.keysOf(items)
    * def questionNumber = QuestionID[0]
    * def AnswerID = items[questionNumber]
    And print questionNumber
    And print AnswerID
    * def featureToBeUsed = read('../Login/Authentication.feature@RegisteredUserLogin')
    * def result = call featureToBeUsed
    * headersToBeUsed["Authorization"] = result.accessToken
    * def parameters = paramsTo.AnswerQuestionParams
    * parameters["question_id"] = questionNumber
    * parameters["answer_id"] = AnswerID
    And print 'Answering'
    Given path pathsTo.MobileAPI.AnswerQuestions
    And params parameters
    And headers headersToBeUsed
    When method GET
    Then status 200
    And match response.status_code == 200
    And match response.message == "Success"
    * def error_msgs = response.error_msgs
    And assert error_msgs.length == 0
    * string jsonResponse = response
    * string JSONSchemaExpected = read('../../schemas/QuestionAnswerResponse.json')
    * assert JavaFunctions.isValid(jsonResponse,JSONSchemaExpected)



