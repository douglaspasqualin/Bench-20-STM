package javaparser;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.SortedSet;
import java.util.TreeSet;

/**
 *
 * @author Douglas Pereira Pasqualin
 */
public class JavaParser {

    private static final int POS_RESULT_TYPE = 0;
    private static final int POS_APPLICATION_NAME = 1;
    private static final int POS_RESULT = 2;
    private static final int POS_NUMBER_THREADS = 3;
    private static final int POS_CONFIGURATION = 4;

    private static final String TIME = "#T";
    private static final String ABORTS = "#A";
    private static final String COMMITS = "#C";

    private static final String TAB = "\t";
    private static final String NEWLINE = "\n";

    private static SortedSet<Application> applications;
    private static StringBuilder outputTime;
    private static StringBuilder outputAborts;
    private static StringBuilder outputCommits;

    private static Application findByNameThreads(String name, Integer numberThreads) {
        for (Application application : applications) {
            if (application.getName().equals(name)
                    && application.getNumberThreads().equals(numberThreads)) {
                return application;
            }
        }
        return null;
    }

    private static void saveToFile(String fileName, StringBuilder builder) throws IOException {
        File file = new File(fileName);
        BufferedWriter writer = null;
        try {
            writer = new BufferedWriter(new FileWriter(file));
            writer.write(builder.toString());
        } finally {
            if (writer != null) {
                writer.close();
            }
        }
    }

    /**
     * @param args the command line arguments
     * @throws java.lang.Exception
     */
    public static void main(String[] args) throws Exception {

        applications = new TreeSet<>();
        outputTime = new StringBuilder();
        outputAborts = new StringBuilder();
        outputCommits = new StringBuilder();

        if (args.length != 1) {
            throw new IllegalArgumentException("Need to pass workdir");
        }

        String workdir = args[0];
        final File folder = new File(workdir);
        for (final File fileEntry : folder.listFiles()) {
            if (!fileEntry.isDirectory() && fileEntry.getName().endsWith(".txt")) {
                Collection<String> lines = Files.readAllLines(fileEntry.toPath(), StandardCharsets.UTF_8);

                //System.out.println("Processing ... "+ fileEntry.getName() + "\n");
                String resultType, name, resultString, configuration;
                Integer threads;
                for (String line : lines) {
                    if (line.startsWith(TIME) || line.startsWith(ABORTS)
                            || line.startsWith(COMMITS)) {
                        String[] elements = line.trim().split("\t");
                        try {
                            resultType = elements[POS_RESULT_TYPE];
                            name = elements[POS_APPLICATION_NAME];
                            resultString = elements[POS_RESULT];
                            threads = Integer.parseInt(elements[POS_NUMBER_THREADS]);
                            configuration = elements[POS_CONFIGURATION];
                        } catch (Exception e) {
                            System.out.println(line);
                            throw e;
                        }

                        Result result;
                        if (resultType.equals(TIME)) {
                            result = new Result(resultString, null, null);
                        } else if (resultType.equals(COMMITS)) {
                            result = new Result(null, resultString, null);
                        } else {
                            result = new Result(null, null, resultString);
                        }
                        //Verify if the application already exits
                        Application application = findByNameThreads(name, threads);
                        if (application != null) {
                            application.addResult(configuration, result);
                        } else {
                            //create new 
                            application = new Application(name, threads);
                            application.addResult(configuration, result);
                            applications.add(application);
                        }
                    }
                }
            }
        }

        for (Application application : applications) {

            for (Map.Entry<String, List<Result>> entry : application.getResults().entrySet()) {

                String key = entry.getKey();
                List<Result> values = entry.getValue();

                for (Result value : values) {
                    if (value.getExecutionTime() != null) {
                        outputTime.append(application.getName()).append(TAB)
                                .append(application.getNumberThreads()).append(TAB)
                                .append(value.getExecutionTime()).append(TAB)
                                .append(key).append(NEWLINE);
                    } else if (value.getAborts() != null) {
                        outputAborts.append(application.getName()).append(TAB)
                                .append(application.getNumberThreads()).append(TAB)
                                .append(value.getAborts()).append(TAB)
                                .append(key).append(NEWLINE);
                    } else {
                        outputCommits.append(application.getName()).append(TAB)
                                .append(application.getNumberThreads()).append(TAB)
                                .append(value.getCommits()).append(TAB)
                                .append(key).append(NEWLINE);
                    }
                }

            }

        }
        
        saveToFile(workdir + "timeExec.txt", outputTime);
//        saveToFile(workdir + "abortsExec.txt", outputAborts);
//        saveToFile(workdir + "commitsExec.txt", outputCommits);
    }
}
