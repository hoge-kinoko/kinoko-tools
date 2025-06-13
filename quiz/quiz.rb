require "js"
require "json"

module Quiz
  class Quiz
    attr_reader :question, :answer, :kana, :tips

    def initialize(data)
      @question = data["question"]
      @answer = data["answer"]
      @kana = data["kana"]
      @tips = data["tips"]
    end

    # 答えが正しいかチェック
    def correct?(user_answer)
      normalize_answer(user_answer) == normalize_answer(@answer)
    end

    # エラーメッセージを生成
    def error_message
      message_parts = [@answer]
      message_parts << @kana if present?(@kana)
      message_parts << @tips if present?(@tips)
      message_parts.join("<br>")
    end

    private

    # 回答を正規化（前後の空白を除去）
    def normalize_answer(answer)
      answer.to_s.strip
    end

    # 値が存在するかチェック
    def present?(value)
      value && !value.empty?
    end
  end

  class QuizManager
    attr_reader :quiz_data

    def initialize
      @quiz_data = []
    end

    # クイズデータを読み込む
    def load_quiz_data
      fetch_quiz_json
        .then { |data| parse_and_store_data(data) }
        .catch { |error| handle_load_error(error) }
    end

    # ランダムにクイズを選択
    def get_random_quizzes(count = Constants::SESSION_SIZE)
      return [] if @quiz_data.empty?

      @quiz_data.sample(count)
    end

    # データが読み込まれているかチェック
    def data_loaded?
      !@quiz_data.empty?
    end

    private

    # JSONデータをフェッチ
    def fetch_quiz_json
      JS.global[:window].fetch("./quiz.json")
        .then(&:json)
    end

    # データを解析して保存
    def parse_and_store_data(data)
      @quiz_data = JsonParser.parse_js_array(data) do |quiz_js|
        quiz_hash = JsonParser.parse_quiz_data(quiz_js)
        Quiz.new(quiz_hash)
      end
      true
    end

    # 読み込みエラーを処理
    def handle_load_error(error)
      JS.global[:console].error("クイズデータの読み込み中にエラーが発生しました:", error)
      false
    end
  end
end
