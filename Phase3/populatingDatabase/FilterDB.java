import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.File;
import java.net.URL;

/**
 * @author Ivan Zelenkov
 */
public class FilterDB {

    private static String tableName;

    public static void main(String[] args) {
        if (args.length == 0) {
            System.out.println("> You forget to pass a table name!");
            return;
        }
        tableName = args[0];
        fileReaderWriter();
    }

    /**
     * Method reads data from a file line by line, checks if each value is an integer or a string,
     * and writes the specified output to the same file in the same format
     */
    private static void fileReaderWriter() {
        try (BufferedReader reader = new BufferedReader(new FileReader(getReadFile().getPath()));
             BufferedWriter writer = new BufferedWriter(new FileWriter(getWriteFile().getPath()))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String output = getSQLInsert(tableName, line);
                writer.write(output);
            }
            writer.write("\ncommit;");
            System.out.println("> Insert statements written successfully");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Method checks if the passed value of type String can be converted to Integer
     * @param token token value
     * @return true or false
     */
    private static boolean isInteger(String token) {
        try {
            Integer.parseInt(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Method loads resources from the classpath
     * @return loaded resources from the classpath
     */
    private static URL getReadFile() {
        return FilterDB.class.getResource(String.format("%s.csv", tableName));
    }

    /**
     * Method writes resources to the classpath
     * @return loaded resources from the classpath
     */
    private static URL getWriteFile() {
        try {
            File file = new File(String.format("%s.sql", tableName));
            if (file.createNewFile())
                System.out.printf("> File %s.sql created\n", tableName);
            else
                System.out.println("> File already exists");
        } catch (IOException e) {
            e.printStackTrace();
        }
        return FilterDB.class.getResource(String.format("%s.sql", tableName));
    }

    /**
     * The method checks the data type of the input line, converts it to the appropriate format, and then creates an INSERT statement
     * @param tableName the name of the SQL table that must be input by the user in order to form INSERT statement
     * @param line tuple is used to form an INSERT statement
     * @return appropriate formatted INSERT statement
     */
    public static String getSQLInsert(String tableName, String line){
        StringBuilder sb = new StringBuilder();
        String[] tokens = line.split(",");
        String separator = "";
        for (String token : tokens) {
            token = token.trim();
            if (isInteger(token) || token.equals("NULL"))
                sb.append(separator).append(token);
            else
                sb.append(separator).append("'").append(token).append("'");
            separator = ", ";
        }
        return "INSERT INTO " + tableName + " VALUES(" + sb + ");\n";
    }
}