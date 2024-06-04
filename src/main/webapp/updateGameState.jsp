<%@ page import="org.example.puzzle.dao.GameStateService" %>
<%@ page import="org.example.puzzle.domain.GameState" %>
<%@ page import="org.example.puzzle.dao.UserService" %>
<%@ page import="org.example.puzzle.dao.PuzzleService" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.time.Instant" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String username = request.getParameter("username");
    String puzzleName = request.getParameter("puzzleName");
    String moveCountParam = request.getParameter("moveCount");
    String solvedParam = request.getParameter("solved");

    if (username == null || puzzleName == null || moveCountParam == null || solvedParam == null) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        out.println("Missing parameters");
        return;
    }

    int moveCount = Integer.parseInt(moveCountParam);
    boolean solved = Boolean.parseBoolean(solvedParam);
    var player = UserService.getByName(username);
    if (player.isEmpty()) {
        out.println("Could not find player " + username);
        return;
    }
    var puzzle = PuzzleService.getByName(puzzleName);
    if (puzzle.isEmpty()) {
        out.println("Could not find puzzle " + puzzleName);
        return;
    }
    GameState currentGameState = new GameState()
            .setPlayerId(player.get().id())
            .setPuzzleId(puzzle.get().id())
            .setMoveCount(moveCount)
            .setFinished(solved)
            .setPlayedAt(Timestamp.from(Instant.now()));

    GameStateService.add(currentGameState);

    out.println("Game state updated successfully");
%>