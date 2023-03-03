package com.veritec.automation.JavaFunctionsAPI;

import com.fasterxml.jackson.databind.JsonNode;
import com.github.fge.jackson.JsonLoader;
import com.github.fge.jsonschema.core.report.ProcessingReport;
import com.github.fge.jsonschema.main.JsonSchema;
import com.github.fge.jsonschema.main.JsonSchemaFactory;

import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;
import java.util.Date;
import java.util.Random;

public class ReusableFunctions {
    public static void writeData(String arg) throws FileNotFoundException, UnsupportedEncodingException {
        PrintWriter writer = new PrintWriter("src/test/resources/Features/api/mobileApi/outputs/data.txt","UTF-8");
        writer.println(arg);
        writer.close();
    }
    public static String getTime() {
        DateFormat dateFormat = new SimpleDateFormat("MMddHHmmssSSS");
        Date date = new Date();
        Calendar cal = Calendar.getInstance();
        return dateFormat.format(cal.getTime());
    }
    public static boolean isValid(String json, String schema){
        try {
            JsonNode schemaNode = JsonLoader.fromString(schema);
            JsonSchemaFactory factory = JsonSchemaFactory.byDefault();
            JsonSchema jsonSchema = factory.getJsonSchema(schemaNode);
            JsonNode jsonNode = JsonLoader.fromString(json);
            ProcessingReport report = jsonSchema.validate(jsonNode);
            return report.isSuccess();
        }catch (Exception ex){
            return false;
        }
    }

    public static String getAlphaNumericString(int n)
    {

        // choose a Character random from this String
        String AlphaNumericString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                + "0123456789"
                + "abcdefghijklmnopqrstuvxyz";

        // create StringBuffer size of AlphaNumericString
        StringBuilder sb = new StringBuilder(n);

        for (int i = 0; i < n; i++) {

            // generate a random number between
            // 0 to AlphaNumericString variable length
            int index
                    = (int)(AlphaNumericString.length()
                    * Math.random());

            // add Character one by one in end of sb
            sb.append(AlphaNumericString
                    .charAt(index));
        }

        return sb.toString().toLowerCase();
    }

    public static String getDateTime() {
        LocalDateTime myDateObj = LocalDateTime.now();
        DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("ddMMyyyyHHmmss");
        String formattedDate = myDateObj.format(myFormatObj);
        return formattedDate;

    }

    public static String getCurrentDateTime() {
        LocalDateTime myDateObj = LocalDateTime.now();
        String Date = myDateObj.toString().substring(0,23);
        String FormattedDate = Date + "Z";
        System.out.println(FormattedDate);
        return FormattedDate;

    }

    public static String getCurrentDateTimeCST() {
        LocalDateTime myDateObj = LocalDateTime.now().plusHours(1);
        String Date = myDateObj.toString().substring(0,23);
        String FormattedDate = Date + "Z";
        System.out.println(FormattedDate);
        return FormattedDate;

    }

    public static String getPastDateTime(int h, int m ) {
        //integer h (hours) and m (mins) are passed where the function is called
        LocalDateTime myDateObj = LocalDateTime.now().minusHours(h).minusMinutes(m);
        String Date = myDateObj.toString().substring(0,23);
        String FormattedDate = Date + "Z";
        System.out.println(FormattedDate);
        return FormattedDate;

    }


    public static int randomNo()
    {
        Random random = new Random();
        int rand = 0;
        while (true){
            rand = random.nextInt(11111);
            if(rand !=0) break;
        }

        return rand;
    }

}
