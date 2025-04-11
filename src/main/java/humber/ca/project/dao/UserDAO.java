package humber.ca.project.dao;

import humber.ca.project.model.User;
import humber.ca.project.model.UserReportDetail;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface UserDAO {
    boolean createUser(User user) throws SQLException;

    Optional<User> findUserByUsername(String username);

    Optional<User> findUserByEmail(String email);

    Optional<User> findUserByUsernameAndPassword(String username, String password);

    Optional<User> findUserById(int id);

    List<User> findAllUsers();

    List<User> searchUser(String searchTerm);

    List<UserReportDetail> getUserReportDetails();
}
