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
      user_answer.strip == @answer
    end
    
    # エラーメッセージを生成
    def error_message
      message = [@answer]
      message << @kana if @kana && !@kana.empty?
      message << @tips if @tips && !@tips.empty?
      message.join("<br>")
    end
  end
  
  class QuizManager
    attr_reader :quiz_data
    
    def initialize
      @quiz_data = []
    end
    
    # クイズデータを読み込む
    def load_quiz_data
      # fetchメソッドを使用してJSONデータを取得
      window = JS.global[:window]
      
      promise = window.fetch("./quiz.json")
        .then { |response| response.json() }
        .then { |data| 
          # JavaScriptの配列を適切に処理
          array_length = data[:length].to_i
          @quiz_data = []
          
          0.upto(array_length - 1) do |i|
            quiz_js = data[i]
            quiz_hash = {
              "question" => quiz_js[:question].to_s,
              "answer" => quiz_js[:answer].to_s
            }
            
            # kanaとtipsは存在する場合のみ追加
            kana_value = quiz_js[:kana]
            tips_value = quiz_js[:tips]
            
            # undefinedやnullでない場合のみ値を設定
            if kana_value && kana_value.to_s != "undefined" && kana_value.to_s != ""
              quiz_hash["kana"] = kana_value.to_s
            end
            
            if tips_value && tips_value.to_s != "undefined" && tips_value.to_s != ""
              quiz_hash["tips"] = tips_value.to_s
            end
            @quiz_data << Quiz.new(quiz_hash)
          end
          
          true
        }
        .catch { |error|
          JS.global[:console].error("クイズデータの読み込み中にエラーが発生しました:", error)
          false
        }
        
      promise
    end
    
    # ランダムにクイズを選択
    def get_random_quizzes(count = 10)
      return [] if @quiz_data.empty?
      
      # Rubyの標準的なシャッフルとスライス
      @quiz_data.sample(count)
    end
  end
end