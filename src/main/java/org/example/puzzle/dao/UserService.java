package org.example.puzzle.dao;


import database.DatabaseConnection;
import org.example.puzzle.domain.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;


public class UserService {
    static private User mapRowToUser(ResultSet row) throws SQLException {
        return new User()
                .setId(row.getInt("id"))
                .setName(row.getString("name"));
    }

    static public Optional<User> getByName(String name) {
        String selectUsersByName = """
                select *
                from wp_user
                where name = ?
                """;
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(selectUsersByName)) {
            statement.setString(1, name);
            ResultSet results = statement.executeQuery();
            if (results.next()) {
                return Optional.of(mapRowToUser(results));
            }
        } catch (SQLException | ClassNotFoundException ignored) {
        }
        return Optional.empty();
    }


    static public Optional<User> getById(int id) {
        String selectUsersById = """
                select *
                from wp_user
                where id = ?
                """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(selectUsersById)) {
            statement.setInt(1, id);
            ResultSet results = statement.executeQuery();
            if (results.next()) {
                return Optional.of(mapRowToUser(results));
            }
        } catch (SQLException | ClassNotFoundException ignored) {
        }
        return Optional.empty();
    }

    static public List<User> getAll() {
        String selectUsersByName = """
                select *
                from wp_user
                """;
        List<User> users = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(selectUsersByName)) {
            ResultSet results = statement.executeQuery();
            while (results.next()) {
                users.add(mapRowToUser(results));
            }
        } catch (SQLException | ClassNotFoundException ignored) {
        }
        return users;
    }

    static public void add(User user) {
        String insertQuery = """
                insert into wp_user (name)
                            value (?)
                """;
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement insertStatement = connection.prepareStatement(insertQuery)) {
            insertStatement.setString(1, user.name());
            insertStatement.executeUpdate();
        } catch (SQLException | ClassNotFoundException ignored) {
        }
    }
}
