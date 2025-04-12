package humber.ca.project.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    private static final String URL = "jdbc:mysql://mysql-3fdf0371-dumpnotfun-4436.b.aivencloud.com:20385/defaultdb?serverTimezone=UTC";
    private static final String USER = "avnadmin";
    private static final String PASSWORD = "AVNS_Pjfbzeh4yJNaolDMB2H";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println(e.getMessage());
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
