package org.example.puzzle.dao;

import database.DatabaseConnection;
import org.example.puzzle.domain.GameState;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class GameStateService {
    static private GameState mapRowToGameState(ResultSet row) throws SQLException {
        return new GameState()
                .setId(row.getInt("id"))
                .setPlayerId(row.getInt("player"))
                .setPuzzleId(row.getInt("puzzle"))
                .setFinished(row.getBoolean("finished"))
                .setMoveCount(row.getInt("move_count"))
                .setPlayedAt(row.getTimestamp("played_at"));
    }

    public static void add(GameState gameState) {
        String query = """
                insert into wp_game_state (player, puzzle, move_count, finished, played_at)
                            value (?, ?, ?, ?, ?)
                """;
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement insertStatement = connection.prepareStatement(query)) {
            insertStatement.setInt(1, gameState.playerId());
            insertStatement.setInt(2, gameState.puzzleId());
            insertStatement.setInt(3, gameState.moveCount());
            insertStatement.setBoolean(4, gameState.finished());
            insertStatement.setTimestamp(5, gameState.playedAt());
            insertStatement.executeUpdate();
        } catch (SQLException | ClassNotFoundException ignored) {
        }
    }

    public static List<GameState> getBestRuns(int puzzle) throws SQLException, ClassNotFoundException {
        String query = """
                select *
                from wp_game_state
                where puzzle = ? and finished = true
                order by move_count
                limit 10
                """;
        List<GameState> games = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, puzzle);
            ResultSet results = statement.executeQuery();
            while (results.next()) {
                games.add(mapRowToGameState(results));
            }
        }
        return games;
    }

}
