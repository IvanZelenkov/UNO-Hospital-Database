import java.sql.*;
import java.util.ArrayList;

public class SelectData {
    private static final String DB_URL = "jdbc:oracle:thin:@dbserver.cs.uno.edu:1521/ORCL";
    private static final String DB_USER = "idzelenk";
    private static final String DB_PASSWORD = "**********";
    private static final String SELECT_NURSE = "SELECT * FROM Nurse";
    private static final String SELECT_PHYSICIAN = "SELECT PHYSICIANID FROM Physician";
    private static final String SELECT_TIMECARD = "SELECT PHYSICIANID FROM Timecard";
        private static final String SELECT_UNREGISTERED_PHYSICIANS = "SELECT PHYSICIANNAME FROM Physician WHERE PHYSICIANID = ?";

    public static void main(String[] args) {
        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {

            /* ****************************** 1 ****************************** */
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Statement statement = connection.createStatement();
            ResultSet nurseData = statement.executeQuery(SELECT_NURSE);
            int totalSalary = 0, numberOfNurses = 0;
            while(nurseData.next()) {
                totalSalary += nurseData.getInt(3);
                numberOfNurses++;
            }
            System.out.println("> Average salary of all nurses: " + totalSalary / numberOfNurses + "\n");

            /* ****************************** 2 ****************************** */
            ResultSet physicianData = statement.executeQuery(SELECT_PHYSICIAN);
            // Add IDs of all physicians
            ArrayList<String> arrayPhysicians = new ArrayList<>();
            while (physicianData.next()) {
                arrayPhysicians.add(physicianData.getString(1));
            }
            System.out.println("> List of physicians: " + arrayPhysicians + "\n");

            ResultSet timeCardData = statement.executeQuery(SELECT_TIMECARD);
            // Add IDs of all physicians who registered time cards
            ArrayList<String> arrayTimeCards = new ArrayList<>();
            while (timeCardData.next()) {
                arrayTimeCards.add(timeCardData.getString(1));
            }
            System.out.println("> Physicians who have submitted a time card: " + arrayTimeCards + "\n");

            // Remove all IDs from arrayPhysicians who registered time cards.
            // If array arrayPhysicians, then somebody did not register a time card.
            arrayPhysicians.removeAll(arrayTimeCards);

            PreparedStatement selectUnregisteredPhysician = connection.prepareStatement(SELECT_UNREGISTERED_PHYSICIANS);

            ArrayList<String> resultArray = new ArrayList<>();
            for (String e : arrayPhysicians) {
                // Set token (ID) in SELECT query
                selectUnregisteredPhysician.setString(1, e);
                // Execute prepared statement
                ResultSet result = selectUnregisteredPhysician.executeQuery();
                // the result set pointer/cursor will be moved to the 1st row (from default position)
                result.next();
                // get ID and add to resultArray
                resultArray.add(result.getString(1));
            }

            if (!resultArray.isEmpty())
                System.out.println("> Physicians who have not submitted a time card:");

            for (String e : resultArray) {
                System.out.println("    * " + e);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            System.out.println("> Error: unable to load Oracle driver class!");
        }
    }
}