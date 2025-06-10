require "js"

module Quiz
  # JSON データの解析を担当するユーティリティクラス
  class JsonParser
    class << self
      # JavaScript配列をRuby配列に変換
      def parse_js_array(js_array, &block)
        return [] unless js_array
        
        array_length = js_array[:length].to_i
        results = []
        
        0.upto(array_length - 1) do |i|
          results << block.call(js_array[i])
        end
        
        results
      end
      
      # JSON文字列を配列として解析
      def parse_json_array(json_data, &block)
        parsed = JS.global[:JSON].parse(json_data)
        parse_js_array(parsed, &block)
      end
      
      # クイズデータをパース
      def parse_quiz_data(js_quiz)
        quiz_hash = {
          "question" => js_quiz[:question].to_s,
          "answer" => js_quiz[:answer].to_s
        }
        
        # オプショナルフィールドの追加
        add_optional_field(quiz_hash, js_quiz, "kana")
        add_optional_field(quiz_hash, js_quiz, "tips")
        
        quiz_hash
      end
      
      private
      
      # オプショナルフィールドを安全に追加
      def add_optional_field(hash, js_object, field_name)
        value = js_object[field_name.to_sym]
        
        if present?(value)
          hash[field_name] = value.to_s
        end
      end
      
      # 値が存在するかチェック
      def present?(value)
        value && 
        value.to_s != "undefined" && 
        value.to_s != "null" && 
        !value.to_s.empty?
      end
    end
  end
end