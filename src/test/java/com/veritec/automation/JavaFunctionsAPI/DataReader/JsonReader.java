package com.veritec.automation.JavaFunctionsAPI.DataReader;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Map;

public class JsonReader {
    static JSONParser parser = new JSONParser();
    /**
     * @param filePath
     * @return
     * @throws FileNotFoundException
     * @throws IOException
     * @throws ParseException
     */
    public static JSONObject getJSONDataURL(String filePath) throws FileNotFoundException, IOException, ParseException {
        Object obj = parser.parse(new FileReader(filePath));
        JSONObject jsonObject = (JSONObject) obj;
        return jsonObject;
    }

    public static String fetchDataJsonObjectArrayObject(JSONObject jsonObject, String textValue, String Identifier, String Datadesc) {
        try {
            jsonObject = (JSONObject) jsonObject.get(textValue);
            jsonObject = (JSONObject) jsonObject.get(Identifier);
            return (String) jsonObject.get(Datadesc);
        }
        catch (Exception ex){
            System.out.println(ex);
            return ex.toString();
        }
    }
    public static Map<String, String> getDataAsMap(JSONObject jsonObject,String textValue, String Identifier) {
        try {
            jsonObject = (JSONObject) jsonObject.get(textValue);
            jsonObject = (JSONObject) jsonObject.get(Identifier);
            return jsonObject;
        }
        catch (Exception ex){
        return null;
        }
    }

}
