import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.net.URL;

public class LoadTimeCardData {
    private static final String DB_URL = "jdbc:oracle:thin:@dbserver.cs.uno.edu:1521/ORCL";
    private static final String DB_USER = "idzelenk";
    private static final String DB_PASSWORD = "**********";
    private static final String DELETE_TABLE_TIMECARD = "DELETE FROM Timecard";
    private static final String INSERT_TIMECARD = "INSERT INTO Timecard VALUES(?, ?, ?)";
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("dd-MMM-yy");

    public static void main(String[] args) {
        loadTimeCardData();
    }

    /**
     * Method reads data from the file line by line, and executes
     * INSERT statement each iteration to insert data using prepared statements
     */
    private static void loadTimeCardData() {
        try (BufferedReader reader = new BufferedReader(new FileReader(getReadFile().getPath()));
             Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {

            Statement statement = connection.createStatement();
            Class.forName("oracle.jdbc.driver.OracleDriver");

            try {
                statement.executeUpdate(DELETE_TABLE_TIMECARD);
            } catch (Exception e) {
                System.out.println("> Delete table error:\n" + e);
            }

            PreparedStatement insertTimeCard = connection.prepareStatement(INSERT_TIMECARD);

            String line;
            while ((line = reader.readLine()) != null) {
                try {
                    String[] tokens = line.split(",");
                    int count = 1;
                    for (String token : tokens) {
                        token = token.trim();
                        if (token.equalsIgnoreCase("null")) {
                            throw new IntegrityConstraintTimeCardException("> Integrity constraint (PHYSICIANFK_TIMECARDTABLE) violated - parent key not found");
                        } else if (isDate(token)) {
                            Date date = DATE_FORMAT.parse(token);
                            insertTimeCard.setDate(count, new java.sql.Date(date.getTime()));
                            count++;
                        } else if (isInteger(token)) {
                            insertTimeCard.setInt(count, Integer.parseInt(token));
                            count++;
                        } else {
                            insertTimeCard.setString(count, token);
                            count++;
                        }
                    }
                    insertTimeCard.executeUpdate();
                } catch (SQLException | ParseException | IntegrityConstraintTimeCardException e) {
                    e.printStackTrace();
                }
            }
            System.out.println("> Data successfully inserted into Table Timecard");
        } catch (IOException | SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            System.out.println("> Error: unable to load Oracle driver class!");
        }
    }

    /**
     * Method loads resources from the filepath
     * @return loaded resources from the filepath
     */
    private static URL getReadFile() {
        return LoadTimeCardData.class.getResource("timecard.csv");
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
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * Method checks if the passed value of type String can be converted to Date
     * @param token token value
     * @return true or false
     */
    private static boolean isDate(String token) {
        try {
            DATE_FORMAT.parse(token);
            return true;
        } catch (ParseException e) {
            return false;
        }
    }
}