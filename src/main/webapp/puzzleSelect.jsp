<%@ page import="org.example.puzzle.domain.Puzzle" %>
<%@ page import="org.example.puzzle.dao.PuzzleService" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="org.example.puzzle.dao.UserService" %>
<%@ page import="org.example.puzzle.domain.User" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.Optional" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Optional<String> maybeUsername = Arrays.stream(request.getCookies())
            .filter((Cookie cookie) -> cookie.getName().equals("username"))
            .findAny()
            .map(cookie -> URLDecoder.decode(cookie.getValue(), StandardCharsets.UTF_8));
    if (maybeUsername.isEmpty()) {
%>Missing username!<%
        return;
    }
    String username = maybeUsername.get();

    if (UserService.getAll()
            .stream()
            .noneMatch((User user) -> user.name().equals(username))) {
        UserService.add(new User().setName(username));
    }
%>
<html>
<head>
    <title>L08</title>
    <style>
        ul {
            list-style-type: none;
        }

        li {
            border: 1px solid black;
            border-collapse: collapse;
            background-color: #c1d2dd;
        }

        li:hover {
            cursor: pointer;
            background-color: #9bc2dc;
        }

        button {
            width: 10rem;
            padding: 1rem;
            border-radius: 0;
            border: 0;
        }

        p {
            padding-left: 2rem;
            padding-right: 2rem;
        }
    </style>
    <script>
        const choiceHandler = (id) => {
            window.location.href = 'puzzle.jsp?id=' + id;
        };
    </script>
</head>
<body>
<h1>List of Puzzles</h1>
<ul>
    <%
        for (Puzzle puzzle : PuzzleService.getAll()) {
    %>
    <li style="display: flex; flex-direction: row; justify-content: space-between"
        onclick="choiceHandler(<%=puzzle.id()%>)"
        id="<%=puzzle.id()%>">
        <p>
            <%= puzzle.name() %>
        </p>
        <p>
            <%= puzzle.pieceCount() * puzzle.pieceCount() %>
            pieces
        </p>
    </li>
    <%
        }
    %>
</ul>
</body>
</html>
