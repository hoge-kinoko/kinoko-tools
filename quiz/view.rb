require "js"

module Quiz
  class View < ::View
    def initialize
      super
      @quiz_manager = QuizManager.new
      @statistics = Statistics.new
      @current_quizzes = []
      @answered_count = 0

      # 統計ビューを初期化
      initialize_statistics_view

      # 初期化時にクイズを読み込んで表示
      load_and_show_quiz
    end

    private

    def load_and_show_quiz
      # クイズデータを読み込む
      @quiz_manager.load_quiz_data.then do |success|
        if success
          show_quiz
        else
          show_error("クイズデータの読み込みに失敗しました。ページを再読み込みしてください。", "quiz")
        end
      end
    end

    def show_quiz
      quiz_container = document.getElementById("quiz")
      return unless quiz_container

      # セッション開始
      @statistics.start_new_session
      @answered_count = 0

      # コンテナをクリア
      quiz_container[:innerHTML] = ""

      # リザルト表示をクリア
      @statistics_view.clear_result_display

      # ランダムにセッション分のクイズを選択
      @current_quizzes = @quiz_manager.get_random_quizzes(Quiz::Constants::SESSION_SIZE)

      # 各クイズを表示
      @current_quizzes.each_with_index do |quiz, index|
        question_number = index + 1
        create_question_element(quiz_container, quiz, question_number)
      end

      # 統計表示を更新
      @statistics_view.update_display
    end

    def create_question_element(container, quiz, number)
      # 質問のコンテナ
      question_div = create_elem("div", container) do |div|
        div[:id] = "question#{number}"
        div[:className] = "question"
      end

      # 質問テキスト
      create_elem("div", question_div) do |div|
        div[:className] = "questionText"
        div[:innerText] = "問題 #{number}: #{quiz.question}"
      end

      # 回答フォーム
      answer_div = create_elem("div", question_div) do |div|
        div[:id] = "answer#{number}"
        div[:className] = "answer"
      end

      create_answer_form(answer_div, quiz, number)
    end

    def create_answer_form(parent, quiz, number)
      form = create_elem("form", parent) do |form_element|
        form_element[:id] = "answerForm#{number}"
        form_element[:autocomplete] = "off"
      end

      # 入力エリアのコンテナ
      input_container = create_elem("div", form) do |div|
        div[:className] = "input-container"
      end

      # テキストボックス
      text_box = create_elem("input", input_container) do |input|
        input[:id] = "answerTextBox#{number}"
        input[:className] = "answerTextBox"
        input[:type] = "text"
      end

      # 回答ボタン
      button = create_elem("button", input_container) do |btn|
        btn[:id] = "answerButton#{number}"
        btn[:className] = "answerButton"
        btn[:type] = "button"
        btn[:innerText] = "回答"
      end

      # 結果表示エリア（フォームの直下に配置）
      result_div = create_elem("div", form) do |div|
        div[:id] = "result#{number}"
        div[:className] = "result"
      end

      # 回答ボタンのクリックイベント
      button.addEventListener("click") do |event|
        event.preventDefault
        check_answer(quiz, text_box, result_div)
      end

      # Enterキーでの送信を防ぐ
      form.addEventListener("submit") do |event|
        event.preventDefault
        false
      end
    end

    def check_answer(quiz, text_box, result_div)
      # 既に正解・不正解が確定している場合はチェック
      current_class = result_div[:className].to_s
      return if current_class.include?("successful") || current_class.include?("failed")

      # 入力値を取得
      user_answer = text_box[:value].to_s

      # 空の入力をチェック
      if user_answer.strip.empty?
        result_div[:innerText] = "回答を入力してください"
        result_div[:className] = "result warning"
        return
      end

      # 警告メッセージをクリア
      if current_class.include?("warning")
        result_div[:innerText] = ""
        result_div[:className] = "result"
      end

      # 答え合わせ
      is_correct = quiz.correct?(user_answer)

      if is_correct
        result_div[:innerText] = "◎"
        result_div[:className] = "result successful"
      else
        # ❌と答えを左右に配置
        result_div[:innerHTML] = ""
        result_div[:className] = "result failed"

        # ❌マーク（左側）
        create_elem("span", result_div) do |span|
          span[:className] = "result-mark"
          span[:innerText] = "✖"
        end

        # 答えの内容（右側）
        create_elem("span", result_div) do |span|
          span[:className] = "result-content"
          span[:innerHTML] = quiz.error_message
        end
      end

      # 統計に記録
      @statistics.record_answer(quiz.question, quiz.answer, user_answer, is_correct)
      @answered_count += 1

      # セッション分すべて回答した場合はリザルトを表示
      if @answered_count >= Quiz::Constants::SESSION_SIZE
        @statistics.complete_current_session
        @statistics_view.show_session_result
      end

      # 統計表示を更新
      @statistics_view.update_display
    end

    # 統計ビューを初期化
    def initialize_statistics_view
      quiz_container = document.querySelector(".quiz-container")
      @statistics_view = StatisticsView.new(@statistics, quiz_container)
    end
  end
end
