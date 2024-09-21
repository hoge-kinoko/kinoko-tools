const head = document.querySelector("head")
head.innerHTML += `
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@materializecss/materialize@2.0.3-alpha/dist/css/materialize.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/@materializecss/materialize@2.0.3-alpha/dist/js/materialize.min.js"></script>
`
document.addEventListener('DOMContentLoaded', function () {
    const header = document.getElementById("header")
    header.innerHTML += `
        <header>
            <nav class="nav-wrapper amber darken-1">
                <a class="brand-logo center" href="/kinoko-tools/index.html">キノ伝ほげぇツール</a>
            </nav>
        </header>
    `
}, true)
