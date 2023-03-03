package com.veritec.automation.Runners;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;
import org.junit.jupiter.api.Test;
import java.io.File;
import java.util.*;


import static com.veritec.automation.utils.CommonUtilities.*;
import static org.junit.Assert.assertTrue;

class ktApiRunnerTest {

    public static Results results;
    @Test
    void testParallel() {
        results = Runner.path("src/test/resources/API/").outputCucumberJson(true).parallel(1);
        generateReport(results.getReportDir());
        testRailIntegration(results);
        reportIntegration(results);
        assertTrue(results.getErrorMessages(), results.getFailCount() == 0);
    }
    public static void generateReport(String karateOutputPath) {
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[] {"json"}, true);
        List<String> jsonPaths = new ArrayList<>(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("src/test/Reports"), "Qa-Automation");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
    }
}
