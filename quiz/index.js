// ページロード時にクイズを表示
window.onload = function() {
    loadQuizDataAndShow();
};

// クイズデータを読み込んで表示する関数
function loadQuizDataAndShow() {
    fetch("./quiz.json")
        .then(response => response.json())
        .then(data => showQuiz(data))
        .catch(error => console.error("クイズデータの読み込み中にエラーが発生しました:", error));
}

// クイズを表示する関数
function showQuiz(quizData) {
    const quizContainer = document.getElementById("quiz");
    // クイズデータから10問をランダムに選択
    const randomQuizzes = getRandomQuizzes(quizData, 10);

    randomQuizzes.forEach((quiz, i) => {
        const index = i + 1;

        const questionDiv = document.createElement("div");
        questionDiv.id = `question${index}`;
        questionDiv.classList.add("question");

        const questionTextDiv = createQuestionTextDiv(index, quiz.question);
        const answerDiv = createAnswerDiv(index, quiz);

        quizContainer.appendChild(questionDiv);
        questionDiv.appendChild(questionTextDiv);
        questionDiv.appendChild(answerDiv);
    });
}

function createQuestionTextDiv(index, questionText) {
    const questionTextDiv = document.createElement("div");
    questionTextDiv.classList.add("questionText");
    questionTextDiv.textContent = `問題 ${index}: ${questionText}`;

    return questionTextDiv;
}

function createAnswerDiv(index, quiz) {
    const answerDiv = document.createElement("div");
    answerDiv.id = `answer${index}`
    answerDiv.classList.add("answer");

    const answerForm = createAnswerForm(index, quiz);

    answerDiv.appendChild(answerForm);
    return answerDiv;
}

function createAnswerForm(index, quiz) {
    const answerForm = document.createElement("form");
    answerForm.id = `answerForm${index}`;
    answerForm.setAttribute("onsubmit", "return false;");
    answerForm.setAttribute("autocomplete", "off");

    const answerTextBox = document.createElement("input");
    answerTextBox.id = `answerTextBox${index}`;
    answerTextBox.classList.add("answerTextBox");
    answerTextBox.setAttribute("type", "text");

    const answerButton = document.createElement("button");
    answerButton.id = `answerButton${index}`;
    answerButton.classList.add("answerButton");
    answerButton.setAttribute("type", "button");
    answerButton.textContent = "回答";

    const resultDiv = document.createElement("div");
    resultDiv.id = `result${index}`;
    resultDiv.classList.add("result");

    answerButton.addEventListener("click", function(){
        const isAnswered = (resultDiv.textContent !== "");
        if(isAnswered) { return; }

        const answerTextBoxValue = answerTextBox.value;
        let result = (answerTextBoxValue === quiz.answer);
        if(result) {
            resultDiv.textContent = "◎"
            resultDiv.classList.add("successful");
        } else {
            let resultHtml =  `✖<br/>${quiz.answer}`
            if(quiz.hasOwnProperty("kana")){
                resultHtml += `<br>${quiz.kana}`
            }
            if (quiz.hasOwnProperty("tips")){
                resultHtml += `<br>${quiz.tips}`
            }
            resultDiv.innerHTML = resultHtml
            resultDiv.classList.add("failed");
        }
    })

    answerForm.appendChild(answerTextBox);
    answerForm.appendChild(answerButton);
    answerForm.appendChild(resultDiv);

    return answerForm;
}

// ランダムにクイズを選択する関数
function getRandomQuizzes(quizArray, num) {
    const shuffled = quizArray.sort(() => 0.5 - Math.random());
    return shuffled.slice(0, num);
}

// リセットボタンのクリックイベント
document.getElementById("reset-button").addEventListener("click", function() {
    // クイズコンテナをクリア
    document.getElementById("quiz").innerHTML = "";
    // クイズを再表示
    loadQuizDataAndShow();
});

document.onkeypress
