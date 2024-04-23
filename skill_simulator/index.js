window.onload = function () {
    load_skill_data()
}

function load_skill_data() {
    fetch("./skill_list.json")
        .then(response => response.json())
        .then(data => set_select(data))
        .catch(error => console.error("技能データの読み込み中にエラーが発生しました。"))
}

function set_select(skill_data) {
    const form = document.getElementById("skill_select")
    const skills_by_rarity = skill_data.reduce((acc, item) => {
        if (!acc[item.rarity_name]) {
            acc[item.rarity_name] = [];
        }
        acc[item.rarity_name].push(item);
        return acc;
    }, {});

    Object.keys(skills_by_rarity).forEach((rarity) => {
        const rarity_name = document.createElement("span");
        rarity_name.textContent = rarity;
        rarity_name.className = "s12 card-title mt-4"
        form.appendChild(rarity_name);

        skills_by_rarity[rarity].forEach((skill) => {
            const label = document.createElement("label");
            label.setAttribute("for", `skill_${skill.id}`);
            label.className = "s3 row"

            const img = document.createElement("img");
            img.setAttribute("src", `images/${skill.id}.png`);
            img.className = "s12"
            img.alt = skill.skill_name;

            const input = document.createElement("input");
            input.setAttribute("type", "checkbox");
            input.id = `skill_${skill.id}`;
            input.className = "s12 filled-in"
            input.value = skill.id;

            const skill_name = document.createElement("span");
            skill_name.innerText = skill.skill_name;
            skill_name.className = "s12 mt-1 mb-2"

            label.appendChild(img);
            label.appendChild(input);
            label.appendChild(skill_name);

            form.appendChild(label)
        })
    })
}
