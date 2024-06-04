package org.example.puzzle.domain;

public class User {
    private int id;
    private String name;

    public User() {

    }

    public int id() {
        return id;
    }

    public String name() {
        return name;
    }

    public User setId(int id) {
        this.id = id;
        return this;
    }

    public User setName(String name) {
        this.name = name;
        return this;
    }
}
