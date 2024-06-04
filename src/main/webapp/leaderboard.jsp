<%@ page import="org.example.puzzle.dao.GameStateService" %>
<%@ page import="org.example.puzzle.domain.GameState" %>
<%@ page import="org.example.puzzle.domain.User" %>
<%@ page import="org.example.puzzle.dao.UserService" %>
<%@ page import="org.example.puzzle.dao.PuzzleService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Optional" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String puzzleIdParam = request.getParameter("id");
    if (puzzleIdParam == null || puzzleIdParam.isEmpty()) {
%>Missing Puzzle Id --- <%=puzzleIdParam%><%
        return;
    }
    int puzzleId = Integer.parseInt(puzzleIdParam);

    List<GameState> gameStates = GameStateService.getBestRuns(puzzleId);

    if (gameStates.isEmpty()) {
%>
<h1 style="color:red">No scores available for this puzzle</h1>
<%
    return;
} else {
%><h1>Top <%=gameStates.size()%> scores</h1><%
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>L08</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        h1 {
            margin-top: 20px;
        }

        table {
            border-collapse: collapse;
            width: 50%;
            margin-top: 20px;
        }

        table, th, td {
            border: 1px solid black;
        }

        th, td {
            padding: 10px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }
    </style>
    <script>
        const goHome = () => {
            window.location.href = 'puzzleSelect.jsp';
        }
    </script>
</head>
<body>
<h1>Leaderboard for Puzzle: <%= PuzzleService.getById(puzzleId).get().name() %>
</h1>
<table>
    <thead>
    <tr>
        <th>Name</th>
        <th>Score</th>
    </tr>
    </thead>
    <tbody>
    <%
        for (GameState gameState : gameStates) {
            Optional<User> maybeUser = UserService.getById(gameState.playerId());
            if (maybeUser.isPresent()) {
                User user = maybeUser.get();
    %>
    <tr>
        <td><%= user.name() %>
        </td>
        <td><%= gameState.moveCount() %>
        </td>
    </tr>
    <%
    } else {
    %>
    <tr>Could not find user?</tr>
    <%
            }
        }
    %>
    </tbody>
</table>
<button onclick="goHome()">Back</button>
</body>
</html>
