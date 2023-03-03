package com.veritec.automation.JavaFunctionsAPI.DataReader;

import com.veritec.automation.JavaFunctionsAPI.ReusableFunctions;
import org.json.simple.JSONObject;

import java.util.Map;

public class EnvConfig extends ReusableFunctions {

    static ReusableFunctions RS = new ReusableFunctions();
    public static String jsonFileType;
    public static JSONObject dataToBeUsed;
    private static final  String PathToFile = "/src/test/resources/Features/api/mobileApi/payloads/";

    // Used Keywords which cannot be changed during execution
    public  String configUserName = "auto"+ RS.getDateTime();
    public  String configFinalRandomEmail = configUserName+"@yopmail.com";
    public  String configRandomUserName = "auto"+ RS.getDateTime();
    public  String configRandomEmail = configRandomUserName+"@yopmail.com";
    public  String configRandomPassword = "Admin123!";
    public static final String configEmail = "moiz@yopmail.com";
    public static final String configPassword = "Admin@123";
    public static final String configDevKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7InRlYW0iOiJRQSIsInB1cnBvc2UiOiJ1c2Vycy1sb2FkLXRlc3RpbmcifSwiaWF0IjoxNjY2MDgyMjM3LCJhdWQiOiJbb2JqZWN0IE9iamVjdF0iLCJpc3MiOiI0MzMtZGV2In0.KZS7RJMFd_If6gNEAa-IAsgZEZfj8FK5ZTaZu-C_x0k";
    public static final String configStagingKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7InRlYW0iOiJRQSIsInB1cnBvc2UiOiJ1c2Vycy1sb2FkLXRlc3RpbmcifSwiaWF0IjoxNjY2MDkxOTI2LCJhdWQiOiJbb2JqZWN0IE9iamVjdF0iLCJpc3MiOiI0MzMtc3RhZ2luZyJ9.MRzLw1OEvCdhBbKbMQzOxBIkTNR1I9tQ9-cKUz9Y4jM";
    public final String configQAKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7InRlYW0iOiJRQSIsInB1cnBvc2UiOiJ1c2Vycy1sb2FkLXRlc3RpbmcifSwiaWF0IjoxNjY2MDkxOTI2LCJhdWQiOiJbb2JqZWN0IE9iamVjdF0iLCJpc3MiOiI0MzMtc3RhZ2luZyJ9.MRzLw1OEvCdhBbKbMQzOxBIkTNR1I9tQ9-cKUz9Y4jM";
    public final String cmsNewsDevToken = "Bearer e992215cd20570e2782101a5fb9922a227ef2c9d025cf9e672a9d229c906225fef55e484e311f26b0e41f26583d08adedd78451102f73cb54e11c35f8d237708b73631278fe8a9925a2d1c759c68f4ef482071487dc80a9ef50c35e3e5ad7bd4fa1583329d89c371aae64ddce3e0afa8ccc8bbbc03b60c8657c20c58fa9d3a80d32553329b115a60982191c3aa5962a097749825360cb96445aa541891df4221473bbaa6185f3d8b8dd6f8b94875f90d429071358528053b2acf8f1b5a342915f4f2b70db19ad71e74bc10460d3c56f98ecb37280bfcdaaf67963b0f5d6c4f7ee7b0b96f00a889e41427329d7c79b74ee82a18853fc16ef031875fc05ea12674ca396fb2cae4d5456f71bc557ead137e";
    public final String cmsNewsQAToken = "Bearer e94754ed081872c4393e88e5dd1aaaa9252468d6e56288f7e533c77aa0701cada220a17c638d3c3d36276e43b7d1e8addd96faf40930fa4ea7b3e3576eb0c73cae5b0fd5a2f49e1345a616db4514ebac6a47ef6715b89509e18d3bc7d418e74c8770bb94ea910779c2c169b547cda63cad11aa06db706c8697002f2d7b63e3e7de8b79bce126b4354b2a531c7bfbc4bd23d1fef2a088ff03b2911a6d36de9eb92bf984e88a9d5b2fc503fd17607ba57aa8ccfcd8a93c744554b2dd85309d2f6ed770edd756216cc8aa669abb2770a664c9c4455e545228ea5d9dee040f3fe8f953e88d2864924a744d9eee4a70fe895e715d7b965706b6ef21607edabc62e85e610c9997933d3fe553789b48e1546ced";
    public static final String cmsNewsStagingToken = "Bearer e992215cd20570e2782101a5fb9922a227ef2c9d025cf9e672a9d229c906225fef55e484e311f26b0e41f26583d08adedd78451102f73cb54e11c35f8d237708b73631278fe8a9925a2d1c759c68f4ef482071487dc80a9ef50c35e3e5ad7bd4fa1583329d89c371aae64ddce3e0afa8ccc8bbbc03b60c8657c20c58fa9d3a80d32553329b115a60982191c3aa5962a097749825360cb96445aa541891df4221473bbaa6185f3d8b8dd6f8b94875f90d429071358528053b2acf8f1b5a342915f4f2b70db19ad71e74bc10460d3c56f98ecb37280bfcdaaf67963b0f5d6c4f7ee7b0b96f00a889e41427329d7c79b74ee82a18853fc16ef031875fc05ea12674ca396fb2cae4d5456f71bc557ead137e";//

    // CMS LABELS
    public static final String devLabels ="";

    public static final String poll_id = "";

    public String title = "API Automation Title "+ RS.getAlphaNumericString(5);
    public static final String description = "API Automation Description";
    // Data Objects
    public static Map<String, String> CreateAccountValidData;
    public static Map<String, String> RegisteredUserLoginData;
    public static Map<String, String> NewsCommentData;

    public static void loadTestDataFile(String environment) {
        try {
        String fileName = environment.toLowerCase()+"DataAPI.json";
        jsonFileType = System.getProperty("user.dir")+ PathToFile + fileName;
        dataToBeUsed = JsonReader.getJSONDataURL(EnvConfig.jsonFileType);
        CreateAccountValidData = JsonReader.getDataAsMap(dataToBeUsed,"CreateAccount", "ValidDetails");
        RegisteredUserLoginData = JsonReader.getDataAsMap(dataToBeUsed,"LoginCredentials", "RegisteredUser_Login");
        NewsCommentData = JsonReader.getDataAsMap(dataToBeUsed,"NewsComment", "ValidNews");
        }
        catch (Exception ex){
            System.out.println("Exception File Not Found");
        }
    }
    public static String getTestDataAsString(String mainObject, String identifier, String value){
        return JsonReader.fetchDataJsonObjectArrayObject(dataToBeUsed,mainObject, identifier, value);
    }
    public String getCMSToken(){
        String environmentToBeUsed = System.getProperty("karate.env").toLowerCase();
        if(environmentToBeUsed.equals("qa")){
            return cmsNewsQAToken;
        }
        else if(environmentToBeUsed.equals("staging")){
            return cmsNewsStagingToken;
        }
        else{
            return cmsNewsDevToken;
        }
    }
    public  String getSecretToken(){
        String environmentToBeUsed = System.getProperty("karate.env").toLowerCase();
        if(environmentToBeUsed.equals("qa")){
            return configQAKey;
        }
        else if(environmentToBeUsed.equals("staging")){
            return configStagingKey;
        }
        else{
            return configDevKey;
        }
    }
}
