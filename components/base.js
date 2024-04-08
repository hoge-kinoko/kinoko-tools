function components_path(file_name) {
    return `/kinoko-tools/components/${file_name}`
}

document.addEventListener('DOMContentLoaded', function() {
    fetch(components_path("head.html"))
        .then(response => response.text())
        .then(data => {
            document.querySelector('head').insertAdjacentHTML('beforeend', data);
        });

    fetch(components_path("header.html"))
        .then((response) => response.text())
        .then((data) => {
            document.querySelector("#header").innerHTML = data

            const top_page_link = document.getElementById("top-page-link")
            top_page_link.setAttribute("href", `./index.html`)
        });
});
