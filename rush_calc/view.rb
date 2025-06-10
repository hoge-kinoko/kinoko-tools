require "js"

class View
  def document
    JS.global["document"]
  end

  def delimited(number)
    return number.to_s if number.abs.to_s.length <= 3

    number.to_s.reverse.scan(/.{1,3}/).join(",").reverse
  end

  def create_elem(tag, parent)
    elem = document.createElement(tag)

    yield(elem) if block_given?

    parent&.appendChild(elem)

    elem
  end
  
  # エラー表示用の共通メソッド
  def show_error(message, container_id = "result")
    container = document.getElementById(container_id)
    return unless container
    
    container[:innerHTML] = ""
    
    error_div = create_elem("div", container) do |div|
      div[:className] = "card-panel red lighten-4"
    end
    
    create_elem("i", error_div) do |icon|
      icon[:className] = "material-icons left"
      icon[:innerText] = "error"
    end
    
    create_elem("span", error_div) do |span|
      span[:className] = "red-text text-darken-4"
      span[:innerText] = message
    end
  end
  
  # 入力値の妥当性を検証する共通メソッド
  def validate_numeric_input(value, field_name, min: 0, max: nil)
    errors = []
    
    # 数値かどうかチェック
    if value.nil? || value.to_s.strip.empty?
      errors << "#{field_name}を入力してください"
    elsif !value.to_s.match?(/\A-?\d+(\.\d+)?\z/)
      errors << "#{field_name}は数値で入力してください"
    else
      num_value = value.to_f
      
      # 最小値チェック
      if num_value < min
        errors << "#{field_name}は#{min}以上の値を入力してください"
      end
      
      # 最大値チェック（指定されている場合）
      if max && num_value > max
        errors << "#{field_name}は#{max}以下の値を入力してください"
      end
    end
    
    errors
  end
end
