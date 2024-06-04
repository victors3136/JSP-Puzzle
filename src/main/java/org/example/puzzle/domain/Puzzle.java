package org.example.puzzle.domain;

public class Puzzle {
    private int id;
    private String name;
    private int pieceCount;

    public Puzzle() {
    }

    public int id() {
        return id;
    }

    public String name() {
        return name;
    }

    public int pieceCount() {
        return pieceCount;
    }

    public Puzzle setId(int id) {
        this.id = id;
        return this;
    }

    public Puzzle setName(String name) {
        this.name = name;
        return this;
    }

    public Puzzle setPieceCount(int pieceCount) {
        this.pieceCount = pieceCount;
        return this;
    }
}
