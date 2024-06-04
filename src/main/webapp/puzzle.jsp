<%@ page import="org.example.puzzle.domain.Puzzle" %>
<%@ page import="org.example.puzzle.dao.PuzzleService" %>
<%@ page import="java.util.Optional" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="org.example.puzzle.dao.UserService" %>
<%@ page import="org.example.puzzle.domain.User" %>
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
    String puzzleIdParam = request.getParameter("id");
    if (puzzleIdParam == null || puzzleIdParam.isEmpty()) {
%>Missing Puzzle Id<%
        return;
    }
    int puzzleId = Integer.parseInt(puzzleIdParam);
    Optional<Puzzle> maybePuzzle = PuzzleService.getById(puzzleId);
    if (maybePuzzle.isEmpty()) {
%>Could not find desired puzzle<%
        return;
    }
    Puzzle puzzle = maybePuzzle.get();
    int gridSize = puzzle.pieceCount();
    String puzzleName = puzzle.name();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>L08</title>
    <style>
        body {
            display: flex;
            flex-direction: column;
            align-items: center;
            font-family: Arial, sans-serif;
        }

        .grid-container {
            display: grid;
            gap: 5px;
            margin-bottom: 20px;
        }

        .grid-cell {
            width: 100px;
            height: 100px;
            border: 1px solid #ccc;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .image-container {
            display: flex;
            gap: 10px;
            overflow-inline: scroll;
            width: 50rem;
        }

        .puzzle-image {
            width: 100px;
            height: 100px;
            cursor: pointer;
            border: 2px solid transparent;
        }

        .puzzle-image.selected {
            box-shadow: 2px 2px 2px #95c5c5;
        }
    </style>
    <script>
        const gridSize = <%= gridSize %>;
        const puzzleName = '<%= puzzleName %>';
        const username = '<%= username %>';
        let selectedImage = null;
        let moveCounter = 0;
        const permute = (n) => {
            let permutation = Array.from({length: n}, (_, i) => i + 1);
            for (let i = n - 1; i > 0; i--) {
                const j = Math.floor(Math.random() * (i + 1));
                [permutation[i], permutation[j]] = [permutation[j], permutation[i]];
            }
            return permutation;
        }

        const puzzleIsSolved = () => {
            const gridCells = document.querySelectorAll('.grid-cell');
            for (let index = 0; index < gridCells.length; index++) {
                const img = gridCells[index].querySelector('img');
                if (!img || img.id !== (index + 1).toString()) {
                    return false;
                }
            }
            return true;
        }
        const updateGameState = async (solvedStatus) => {
            try {
                await fetch('updateGameState.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'username=' + username +
                        '&puzzleName=' + puzzleName +
                        '&moveCount=' + moveCounter +
                        '&solved=' + solvedStatus
                });
            } catch (err) {
                console.log('oooopsie daisy');
            }
        }
        const selectImage = (event) => {
            if (selectedImage) {
                selectedImage.classList.remove('selected');
            }
            selectedImage = event.target;
            selectedImage.classList.add('selected');
        }

        const placeImage = (cell) => {
            if (!selectedImage) {
                console.log('No image selected');
                return;
            }
            moveCounter++;
            const img = document.createElement('img');
            img.src = selectedImage.src;
            img.id = selectedImage.id;
            img.classList.add('puzzle-image');
            cell.innerHTML = '';
            cell.appendChild(img);
            const solved = puzzleIsSolved();
            updateGameState(solved);
            if (solved) {
                window.alert("You solved me!");
                window.location.href = 'leaderboard.jsp?id=' +<%=puzzleId%>;
            }
        }

        const createGrid = () => {
            const gridContainer = document.getElementById('grid-container');
            gridContainer.style.gridTemplateColumns = 'repeat(' + gridSize + ', 100px)';
            gridContainer.style.gridTemplateRows = 'repeat(' + gridSize + ', 100px)';
            for (let index = 0; index < gridSize * gridSize; index++) {
                const cell = document.createElement('div');
                cell.id = index.toString();
                cell.classList.add('grid-cell');
                cell.addEventListener('click', () => {
                    placeImage(cell);
                });
                gridContainer.appendChild(cell);
            }
        }

        const createImageElement = (index) => {
            const img = document.createElement('img');
            img.src = 'photos/' + puzzleName + '/' + index + '.jpg';
            img.alt = 'Puzzle Piece ' + index;
            img.id = index.toString();
            img.classList.add('puzzle-image');
            img.addEventListener('click', selectImage);
            return img;
        }

        const createImageElements = () => {
            const imageContainer = document.getElementById('image-container');
            for (let index of permute(gridSize * gridSize)) {
                imageContainer.appendChild(createImageElement(index));
            }
        }

        const setup = () => {
            createGrid();
            createImageElements();
        }

        window.onload = setup;
    </script>
</head>
<body>
<div class="grid-container" id="grid-container"></div>
<div class="image-container" id="image-container"></div>
</body>
</html>
