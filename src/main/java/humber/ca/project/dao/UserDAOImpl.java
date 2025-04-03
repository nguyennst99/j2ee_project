package humber.ca.project.dao;

import humber.ca.project.model.Role;
import humber.ca.project.model.User;
import humber.ca.project.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class UserDAOImpl implements UserDAO {
    private Connection con;
    private PreparedStatement ps;
    private ResultSet rs;

    private void closeConnection() throws SQLException {
        if (rs != null) {
            rs.close();
        }
        if (ps != null) {
            ps.close();
        }
        if (con != null) {
            con.close();
        }
    }

    @Override
    public boolean createUser(User user) {
        try {
            con = DBUtil.getConnection();
            String insert_user_sql =
                            "INSERT INTO users (username, password, email, cellphone, name, address, role) " +
                            "VALUES (?, ?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(insert_user_sql);

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getCellphone());
            ps.setString(5, user.getName());
            ps.setString(6, user.getAddress());
            ps.setString(7, user.getRole() != null ? user.getRole().name() : Role.user.name());

            int row = ps.executeUpdate();
            return row > 0;
        } catch (SQLException e) {
            System.out.println("SQL Exception creating user: " + e.getMessage());
        } finally {
            try {
                closeConnection();
            } catch (SQLException e) {
                System.out.println("SQL Exception closing connection: " + e.getMessage());
            }
        }
        return false;
    }

    @Override
    public Optional<User> findUserByUsername(String username) {
        User user = null;
        try {
            con = DBUtil.getConnection();
            String get_user_by_username_sql =
                            "SELECT id, username, password, email, cellphone, name, address, role " +
                            "FROM users " +
                            "WHERE username = ?";
            ps = con.prepareStatement(get_user_by_username_sql);

            ps.setString(1, username);
            rs = ps.executeQuery();

            if (rs.next()) {
                user = mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            System.out.println("SQL Exception finding user by username: " + e.getMessage());
        } finally {
            try {
                closeConnection();
            } catch (SQLException e) {
                System.out.println("SQL Exception closing connection: " + e.getMessage());
            }
        }
        return Optional.ofNullable(user);
    }

    @Override
    public Optional<User> findUserByEmail(String email) {
        User user = null;
        try {
            con = DBUtil.getConnection();
            String get_user_by_email_sql =
                            "SELECT id, username, password, email, cellphone, name, address, role " +
                            "FROM users WHERE email = ?";
            ps = con.prepareStatement(get_user_by_email_sql);

            ps.setString(1, email);
            rs = ps.executeQuery();

            if (rs.next()) {
                user = mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            System.out.println("SQL Exception finding user by email: " + e.getMessage());
        } finally {
            try {
                closeConnection();
            } catch (SQLException e) {
                System.out.println("SQL Exception closing connection: " + e.getMessage());
            }
        }
        return Optional.ofNullable(user);
    }

    @Override
    public Optional<User> findUserByUsernameAndPassword(String username, String password) {
        User user = null;
        try {
            con = DBUtil.getConnection();
            String get_user_by_username_and_password_sql =
                            "SELECT id, username, password, email, cellphone, name, address, role " +
                            "FROM users " +
                            "WHERE username = ? AND password = ?";
            ps = con.prepareStatement(get_user_by_username_and_password_sql);

            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                user = mapResultSetToUser(rs);
            }

        } catch (SQLException e) {
            System.out.println("SQL Exception finding user by username and password: " + e.getMessage());
        } finally {
            try {
                closeConnection();
            } catch (SQLException e) {
                System.out.println("SQL Exception closing connection: " + e.getMessage());
            }
        }
        return Optional.ofNullable(user);
    }

    @Override
    public Optional<User> findUserById(int id) {
        User user = null;
        try {
            con = DBUtil.getConnection();
            String get_user_by_id_sql =
                            "SELECT id, username, password, email, cellphone, name, address, role " +
                            "FROM users WHERE id = ?";
            ps = con.prepareStatement(get_user_by_id_sql);

            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                user = mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            System.out.println("SQL Exception finding user by id: " + e.getMessage());
        }
        return Optional.ofNullable(user);
    }

    @Override
    public List<User> findAllUsers() {
        List<User> users = new ArrayList<>();
        try {
            con = DBUtil.getConnection();
            String get_all_users_sql =
                            "SELECT id, username, email, cellphone, name, address, role " +
                            "FROM users";
            ps = con.prepareStatement(get_all_users_sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }

        } catch (SQLException e) {
            System.out.println("SQL Exception finding all users: " + e.getMessage());
        } finally {
            try {
                closeConnection();
            } catch (SQLException e) {
                System.out.println("SQL Exception closing connection: " + e.getMessage());
            }
        }
        return users;
    }

    @Override
    public List<User> searchUser(String searchTerm) {
        List<User> users = new ArrayList<>();
        try {
            con = DBUtil.getConnection();
            String search_user_sql =
                            "SELECT id, username, email, cellphone, name, address, role " +
                            "FROM users " +
                            "WHERE username LIKE ? OR email LIKE ? OR name LIKE ?";
            ps = con.prepareStatement(search_user_sql);

            ps.setString(1, searchTerm);
            ps.setString(2, searchTerm);
            ps.setString(3, searchTerm);

            rs = ps.executeQuery();
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            System.out.println("SQL Exception searching user: " + e.getMessage());
        } finally {
            try {
                closeConnection();
            } catch (SQLException e) {
                System.out.println("SQL Exception closing connection: " + e.getMessage());
            }
        }
        return users;
    }

    /**
     * Helper method to map ResultSet row to User object
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setCellphone(rs.getString("cellphone"));
        user.setName(rs.getString("name"));
        user.setAddress(rs.getString("address"));
        user.setRoleFromString(rs.getString("role"));
        return user;
    }
}