document.addEventListener('DOMContentLoaded', function() {
    const head = document.querySelector("head")
    head.innerHTML += `
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@materializecss/materialize@2.0.3-alpha/dist/css/materialize.min.css">
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    `

    const header = document.getElementById("header")
    header.innerHTML += `
    <header>
        <nav class="nav-wrapper amber darken-1">
            <a class="brand-logo center" href="/kinoko-tools/index.html">キノ伝ツール保管庫</a>
        </nav>
    </header>
    `
});

