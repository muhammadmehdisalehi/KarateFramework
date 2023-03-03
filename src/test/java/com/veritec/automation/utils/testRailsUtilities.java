package com.veritec.automation.utils;

import com.veritec.automation.JavaFunctionsAPI.ReusableFunctions;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class testRailsUtilities {
    public static APIClient createConnection(){
        try {
            APIClient client = new APIClient("https://cloudprimero.testrail.io/");
            client.setUser("xyz@cloudprimero.com");
            client.setPassword("Password");
            return client;
        }
        catch (Exception ex){
            System.out.println(ex);
            return null;
        }
    }
    public static String createRun(ArrayList<Long> arrayToBeUsed){
        try {
            String stringToParse = "";
            if(System.getProperty("karate.BuildNumber") != null && System.getProperty("karate.BuildName") != null){
                stringToParse = "{\n" +
                        "    \"suite_id\": 1,\n" +
                        "    \"name\": \""+System.getProperty("karate.BuildName")+" For Build# "+System.getProperty("karate.BuildNumber")+" - "+ ReusableFunctions.getTime()+"\",\n" +
                        "    \"include_all\": false,\n" +
                        "    \"case_ids\": "+arrayToBeUsed+"\n" +
                        "}";
            }
            else{
                stringToParse = "{\n" +
                        "    \"suite_id\": 1,\n" +
                        "    \"name\": \"This is a Automated test run - "+ ReusableFunctions.getTime()+"\",\n" +
                        "    \"include_all\": false,\n" +
                        "    \"case_ids\": "+arrayToBeUsed+"\n" +
                        "}";
            }
            JSONParser parser = new JSONParser();
            JSONObject json = (JSONObject) parser.parse(stringToParse);
            APIClient client = createConnection();
            JSONObject c = (JSONObject) client.sendPost("add_run/1",json);
            return c.get("id").toString();
        }
        catch (Exception ex){
            System.out.println(ex.toString());
            return "-1";
        }
    }
    public static void closeRun(String runID){
        try {
            String stringToParse = "{}";
            JSONParser parser = new JSONParser();
            JSONObject json = (JSONObject) parser.parse(stringToParse);
            APIClient client = createConnection();
            JSONObject c = (JSONObject) client.sendPost("close_run/"+runID,json);
            System.out.println(c);
        }
        catch (Exception ex){
            System.out.println(ex.toString());
        }
    }
    public static void addResults(Map<String, List<String>> mapToBeUsed){
        String flagForRunID = "-1";
        try {
            ArrayList<Long> testCasesArray = getArrayOfTestCases(mapToBeUsed);
            flagForRunID = createRun(testCasesArray);
            if (flagForRunID != "-1") {
                String tempPayload="";
                int statusOfPayload=0;
                for ( String key : mapToBeUsed.keySet() ) {
                    int testCaseID = Integer.parseInt(key.substring(key.indexOf("-")+1));
                    List<String> tempList = mapToBeUsed.get(key);
                    String statusOfTestCase = tempList.get(0);
                    String commentTobe = tempList.get(1);
                    if(statusOfTestCase.equals("passed")){
                        statusOfPayload = 1;
                    }
                    else {
                        statusOfPayload = 5;
                    }
                    tempPayload =tempPayload+"{ \"case_id\":"+testCaseID+",\"status_id\":"+statusOfPayload+",\"comment\":\""+commentTobe.replaceAll("\\\"", "\\\\\"")+"\"},";
                }
                String nameFinal = tempPayload.substring(0,tempPayload.lastIndexOf(","));
                String stringToParse = "{\"results\" : ["+nameFinal+"]}";
                JSONParser parser = new JSONParser();
                JSONObject json = (JSONObject) parser.parse(stringToParse);
                APIClient client = createConnection();
                JSONArray c = (JSONArray) client.sendPost("add_results_for_cases/"+flagForRunID, json);
                closeRun(flagForRunID);
            }
        }
        catch (Exception ex){
            System.out.println(ex.toString());
        }
    }
    public static void addResultsForTestCases(Map<String, List<String>> mapToBeUsed){
        try {
                String tempPayload="";
                for ( String key : mapToBeUsed.keySet() ) {
                    int testCaseID = Integer.parseInt(key.substring(key.indexOf("-")+1));
                    List<String> tempList = mapToBeUsed.get(key);
                    String statusOfTestCase = tempList.get(0);
                    String doc_String = tempList.get(2);
                    if(statusOfTestCase.equals("passed")) {
                        String custom_request = doc_String.substring(0,doc_String.indexOf("\n\n\n"));
                        String custom_response = doc_String.substring(doc_String.indexOf("\n\n\n")+3);
                        custom_request = custom_request.replaceAll("\\\"", "\\\\\"");
                        custom_response = custom_response.replaceAll("\\\"", "\\\\\"");
                        tempPayload = "{ \"custom_request\":\""+custom_request+"\",\"custom_response\":\""+custom_response+"\"}";
                        JSONParser parser = new JSONParser();
                        JSONObject json = (JSONObject) parser.parse(tempPayload);
                        APIClient client = createConnection();
                        JSONObject c = (JSONObject) client.sendPost("update_case/" + testCaseID, json);
                    }
                }
        }
        catch (Exception ex){
            System.out.println("Status of test cases are not updated!");
        }
    }
    public static ArrayList<Long> getArrayOfTestCases(Map<String, List<String>> mapToBeUsed){
        ArrayList<Long> arrayOfTestCases = new ArrayList<Long>();
        int counter = 0;
        try{
            for ( String key : mapToBeUsed.keySet() ) {
                int testCaseID = Integer.parseInt(key.substring(key.indexOf("-")+1));
                long testCaseIDLong = testCaseID;
                arrayOfTestCases.add(testCaseIDLong);
            }
            return arrayOfTestCases;
        }catch (Exception ex){
            return null;
        }
    }
    public static void getBodyOfCasesPayload(Map<String,String> mapToBeUsed){
        try{
            String tempPayload="";
            int statusOfPayload=0;
            for ( String key : mapToBeUsed.keySet() ) {
                int testCaseID = Integer.parseInt(key.substring(key.indexOf("-")+1,key.lastIndexOf("-")));
                String statusOfTestCase = key.substring(key.lastIndexOf("-")+1);
                if(statusOfTestCase.equals("passed")){
                    statusOfPayload = 1;
                }
                else {
                    statusOfPayload = 5;
                }
               tempPayload =tempPayload+"{ \"case_id\":"+testCaseID+",\"status_id\":"+statusOfPayload+"},";
            }
            String nameFinal = tempPayload.substring(0,tempPayload.lastIndexOf(","));
            String stringToParse = "{\"results\" : ["+nameFinal+"]}";
            JSONParser parser = new JSONParser();
            JSONObject json = (JSONObject) parser.parse(stringToParse);
            System.out.println(json);
        }catch (Exception ex){
            System.out.println(ex);
        }
    }
    public static void getResults(){
        try {
            APIClient client = createConnection();
            JSONObject c = (JSONObject) client.sendGet("get_case/55");
            System.out.println(c.get(c.toString()));
        }
        catch (Exception ex){
            System.out.println(ex.toString());
        }
    }
    public static void updateTestCases(){}
}
