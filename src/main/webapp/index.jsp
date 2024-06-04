<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>L08</title>
    <style>

        body {
            margin: 5rem;
            display: flex;
            width: 20rem;
        }
        form {
            margin: 1rem;
        }
        form div {
            margin: 1rem;
        }
        button{
            width: 20rem;
            padding: 1rem;
            border-radius: 0;
            border: 0;
            margin: 1rem;
            flex-direction: column;
        }
    </style>
</head>

<body>
<form id="name-form" method="get">
    <div style="width:20rem"
    >
        <label for="name-input">Enter your name</label>
        <input id="name-input" type="text" minlength="1" style="width: 12.6rem"/>
    </div>
    <button type="submit">
        Start Puzzle
    </button>
</form>
<script>
    document.cookie = "path=/";//reset cookies whenever back on main screen
    const handler = (event) => {
        event.preventDefault();
        const name = document.getElementById("name-input").value;
        if (!name || !name.trim().length) {
            alert("Please enter your name to continue");
            return;
        }
        const encodedName = encodeURIComponent(name);
        document.cookie = "username=" + encodedName + ";path=/";
        window.location.href = "puzzleSelect.jsp";
    };
    document.getElementById("name-form").addEventListener("submit", handler);
</script>
</body>
</html>