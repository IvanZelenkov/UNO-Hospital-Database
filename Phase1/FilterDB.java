import java.io.*;
import java.net.URL;

/**
 * @author Ivan Zelenkov
 */
public class FilterDB {
    public static void main(String[] args) {
        fileReaderWriter();
    }

    /**
     * The method reads data from a file, checks if each value is an integer or a string, and writes the specified output to the same file in the same format
     */
    private static void fileReaderWriter() {
        try (BufferedReader reader = new BufferedReader(new FileReader(getReadFile().getPath()));
             BufferedWriter writer = new BufferedWriter(new FileWriter(getWriteFile().getPath()))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] tokens = line.split(",");
                String separator = "";
                for (String token : tokens) {
                    token = token.trim();
                    if (isInteger(token))
                        writer.write(separator + "Integer");
                    else
                        writer.write(separator + "Text");
                    separator = ", ";
                }
                writer.write("\n");
            }
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
        return FilterDB.class.getResource("phase1.csv");
    }

    /**
     * Method writes resources to the classpath
     * @return loaded resources from the classpath
     */
    private static URL getWriteFile() {
        try {
            File file = new File("output.txt");
            if (file.createNewFile())
                System.out.println("> File output.txt created\n");
            else
                System.out.println("> File output.txt already exists");
        } catch (IOException e) {
            e.printStackTrace();
        }
        return FilterDB.class.getResource("output.txt");
    }
}