package org.example.puzzle.domain;

import java.sql.Timestamp;
import java.time.Instant;

public class GameState {
    private int id;
    private int puzzleId;
    private int playerId;
    private int moveCount = 0;
    private boolean finished = false;
    private Timestamp playedAt = Timestamp.from(Instant.now());

    public GameState() {

    }

    public int id() {
        return id;
    }

    public int puzzleId() {
        return puzzleId;
    }

    public int playerId() {
        return playerId;
    }

    public int moveCount() {
        return moveCount;
    }

    public boolean finished() {
        return finished;
    }

    public Timestamp playedAt() {
        return playedAt;
    }

    public GameState setId(int id) {
        this.id = id;
        return this;
    }

    public GameState setPuzzleId(int puzzleId) {
        this.puzzleId = puzzleId;
        return this;
    }

    public GameState setPlayerId(int playerId) {
        this.playerId = playerId;
        return this;
    }

    public GameState setMoveCount(int moveCount) {
        this.moveCount = moveCount;
        return this;
    }

    public GameState setFinished(boolean finished) {
        this.finished = finished;
        return this;
    }

    public GameState setPlayedAt(Timestamp playedAt) {
        this.playedAt = playedAt;
        return this;
    }
}
