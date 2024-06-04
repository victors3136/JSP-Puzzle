package org.example.puzzle.dao;

import database.DatabaseConnection;
import org.example.puzzle.domain.Puzzle;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class PuzzleService {
    static private Puzzle mapRowToPuzzle(ResultSet row) throws SQLException {
        return new Puzzle()
                .setId(row.getInt("id"))
                .setName(row.getString("name"))
                .setPieceCount(row.getInt("piece_count"));
    }

    static public Optional<Puzzle> getByName(String name) {
        String selectPuzzleByName = """
                select *
                from wp_puzzle
                where name = ?
                """;
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(selectPuzzleByName)) {
            statement.setString(1, name);
            ResultSet results = statement.executeQuery();
            if (results.next()) {
                return Optional.of(mapRowToPuzzle(results));
            }
        } catch (SQLException | ClassNotFoundException ignored) {
        }
        return Optional.empty();
    }

    static public Optional<Puzzle> getById(int id) {
        String selectPuzzleById = """
                select *
                from wp_puzzle
                where id = ?
                """;
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(selectPuzzleById)) {
            statement.setInt(1, id);
            ResultSet results = statement.executeQuery();
            if (results.next()) {
                return Optional.of(mapRowToPuzzle(results));
            }
        } catch (SQLException | ClassNotFoundException ignored) {
        }
        return Optional.empty();
    }

    static public List<Puzzle> getAll() {
        String selectPuzzles = """
                select *
                from wp_puzzle
                """;
        List<Puzzle> users = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(selectPuzzles)) {
            ResultSet results = statement.executeQuery();
            while (results.next()) {
                users.add(mapRowToPuzzle(results));
            }
        } catch (SQLException | ClassNotFoundException ignored) {
        }
        return users;
    }

    public void add(Puzzle puzzle) {
        String query = """
                insert into wp_puzzle (name, piece_count)
                            value (?, ?)
                """;
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement insertStatement = connection.prepareStatement(query)) {
            insertStatement.setString(1, puzzle.name());
            insertStatement.setInt(2, puzzle.pieceCount());
            insertStatement.executeUpdate();
        } catch (SQLException | ClassNotFoundException ignored) {
        }
    }
}
