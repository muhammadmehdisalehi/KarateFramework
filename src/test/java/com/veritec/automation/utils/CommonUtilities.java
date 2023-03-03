package com.veritec.automation.utils;

import com.intuit.karate.Results;
import org.apache.commons.io.FileUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

import static com.veritec.automation.utils.testRailsUtilities.addResults;
import static com.veritec.automation.utils.testRailsUtilities.addResultsForTestCases;

public class CommonUtilities {
    public static void testRailIntegration(Results results){
        Map<String, List<String>> finalMap = new HashMap<String,List<String>>();
        try {
            if (System.getProperty("karate.testRailIntegration") != null && System.getProperty("karate.testRailIntegrationTestCaseUpdation") != null) {
                String testRailIntegration = System.getProperty("karate.testRailIntegration").toLowerCase();
                String testRailIntegrationTestCaseUpdation = System.getProperty("karate.testRailIntegrationTestCaseUpdation").toLowerCase();
                if (testRailIntegration.toLowerCase().equals("true")) {
                    finalMap = afterEachScenarioToBeCalledFiles(results.getReportDir());
                    if (!finalMap.isEmpty()) {
                        addResults(finalMap);
                        if (testRailIntegrationTestCaseUpdation.toLowerCase().equals("true")) {
                            addResultsForTestCases(finalMap);
                        }
                    }
                }
            }
        }
        catch (Exception ex){
            System.out.println("Test Rail Integration Failed");
        }
    }
    public static Map<String, List<String>> afterEachScenarioToBeCalledFiles(String karateOutputPath){
        Map<String, List<String>> finalMap = new HashMap<String,List<String>>();
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[] {"json"}, true);
        List<String> jsonPaths = new ArrayList<>(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        for (int i = 0;i<jsonFiles.size();i++){
            JSONObject jsonObject = getJSONDataURLAsJsonObject(jsonPaths.get(i));
            finalMap.putAll(getScenariosCountInJson1(jsonObject));
        }

        return finalMap;
    }
    public static JSONObject getJSONDataURLAsJsonObject(String filePath){
        JSONObject jsonObject = null;
        try {
            JSONParser parser = new JSONParser();
            Object obj = parser.parse(new FileReader(filePath));
            JSONArray mainArray = (JSONArray) obj;
            jsonObject = (JSONObject) mainArray.get(0);
            System.out.println(jsonObject);
            return jsonObject;
        }
        catch (Exception ex){
            return jsonObject;
        }
    }
    public static Map<String, String> getScenariosCountInJson(JSONObject jsonObject){
        Map<String, String> returningMap = new HashMap<String, String>();
        String finalTag = null;
        boolean flagForTag = false;
        String flagForStatus = "fail";
        try {
            flagForTag = false;
            JSONArray mainArray = (JSONArray) jsonObject.get("elements");
            JSONObject childObj = null;
            for (int i = 0; i < mainArray.size(); i++) {
                childObj = (JSONObject) mainArray.get(i);
                if (childObj.get("type").equals("scenario")) {
                    JSONArray childArrayTags = (JSONArray) childObj.get("tags");
                    JSONArray childArray = (JSONArray) childObj.get("steps");
                    for (int k = childArrayTags.size()-1; k >= 0; k--) {
                        JSONObject grandChildTagsObj = (JSONObject) childArrayTags.get(k);
                        if (grandChildTagsObj.get("name").toString().contains("@TESTID")) {
                            finalTag = grandChildTagsObj.get("name").toString();
                            //returningMap.put(finalTag,"");
                            flagForTag = true;
                        }
                    }
                    if(flagForTag == true) {
                        for(int l = 0; l < childArray.size(); l++){
                            JSONObject grandChildStatusObj = (JSONObject) childArray.get(l);
                            JSONObject greatGrandChildStatusObj = (JSONObject) grandChildStatusObj.get("result");
                            if(greatGrandChildStatusObj.get("status").equals("passed")){
                                flagForStatus = "passed";
                            }
                            else{
                                flagForStatus = "failed";
                                break;
                            }
                        }
                        for (int j = childArray.size() - 1; j >= 0; j--) {
                            JSONObject grandChildObj = (JSONObject) childArray.get(j);
                            if (grandChildObj.get("name").toString().contains("method")) {
                                JSONObject objToGet = (JSONObject) grandChildObj.get("doc_string");
                                returningMap.put(finalTag+"-"+flagForStatus, objToGet.get("value").toString());
                                flagForTag = false;
                                break;
                            }
                        }
                    }
                }
            }
            return returningMap;
        }
        catch (Exception ex){
            return returningMap;
        }
    }
    public static Map<String, List<String>> getScenariosCountInJson1(JSONObject jsonObject){
        List<String> tempList=new ArrayList<String>();
        Map<String, List<String>> returningMap1 = new HashMap<String, List<String>>();
        String finalTag = null;
        boolean flagForTag = false;
        String flagForStatus = "fail";
        String errorMessage = "";
        try {
            flagForTag = false;
            JSONArray mainArray = (JSONArray) jsonObject.get("elements");
            JSONObject childObj = null;
            for (int i = 0; i < mainArray.size(); i++) {
                childObj = (JSONObject) mainArray.get(i);
                if (childObj.get("type").equals("scenario")) {
                    JSONArray childArrayTags = (JSONArray) childObj.get("tags");
                    JSONArray childArray = (JSONArray) childObj.get("steps");
                    for (int k = childArrayTags.size()-1; k >= 0; k--) {
                        JSONObject grandChildTagsObj = (JSONObject) childArrayTags.get(k);
                        if (grandChildTagsObj.get("name").toString().contains("@TESTID")) {
                            finalTag = grandChildTagsObj.get("name").toString();
                            //returningMap.put(finalTag,"");
                            flagForTag = true;
                        }
                    }
                    if(flagForTag == true) {
                        for(int l = 0; l < childArray.size(); l++){
                            JSONObject grandChildStatusObj = (JSONObject) childArray.get(l);
                            JSONObject greatGrandChildStatusObj = (JSONObject) grandChildStatusObj.get("result");
                            if(greatGrandChildStatusObj.get("status").equals("passed")){
                                flagForStatus = "passed";
                                errorMessage = "This test case is passed successfully!";
                            }
                            else{
                                flagForStatus = "failed";
                                errorMessage = greatGrandChildStatusObj.get("error_message").toString();
                                break;
                            }
                        }
                        for (int j = childArray.size() - 1; j >= 0; j--) {
                            JSONObject grandChildObj = (JSONObject) childArray.get(j);
                            if (grandChildObj.get("name").toString().contains("method")) {
                                JSONObject objToGet = (JSONObject) grandChildObj.get("doc_string");
                                tempList.add(flagForStatus);
                                tempList.add(errorMessage);
                                tempList.add(objToGet.get("value").toString());
                                returningMap1.put(finalTag,tempList);
                                tempList =new ArrayList<String>();
                                //tempList.clear();
                                //tempMap.remove("status");
                                //tempMap.remove("error_message");
                                //tempMap.remove("docString");
                                //returningMap.put(finalTag+"-"+flagForStatus, objToGet.get("value").toString());
                                flagForTag = false;
                                break;
                            }
                        }
                    }
                }
            }
            return returningMap1;
        }
        catch (Exception ex){
            return returningMap1;
        }
    }
    public static void reportIntegration(Results results){
        try {
            File f = new File(System.getProperty("user.dir")+"/buildOutput.txt");
            Path fileToDeletePath = Paths.get(System.getProperty("user.dir")+"/buildOutput.txt");
            if(f.exists() && !f.isDirectory()) {
                Files.delete(fileToDeletePath);
            }
            int totalScenarios = results.getScenariosTotal();
            int scenarioFailedCount = results.getFailCount();
            int scenarioPassed = results.getScenariosPassed();
            String message = "*Total Scenarios* : " + totalScenarios + "\n*Scenarios Passed* : " + scenarioPassed + "\n*Scenarios Failed* : " + scenarioFailedCount;
            FileWriter myWriter = new FileWriter(System.getProperty("user.dir")+"/buildOutput.txt");
            myWriter.write(message);
            myWriter.close();
            System.out.println("Successfully wrote to the file.");
        }
        catch (Exception ex){
            System.out.println("Report File Creation Failed");
            System.out.println(ex);
        }
    }

    // NO usage
    /*void afterEachScenarioToBeCalled(){
        results1 = results;
        int numberOfScenarios = results.getScenariosTotal();
        System.out.println(results.toKarateJson());
        Stream abc1 = results.getScenarioResults();
        String abc = String.valueOf(results.getSuite().features.get(0).feature.getSection(0).getScenario().getSteps());
        results.getSuite();
        for(int i = 0; i < numberOfScenarios; i++)
        {
            System.out.println("Number of scenarios :: "+abc);
        }
    }*/
}
