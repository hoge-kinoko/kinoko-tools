require "js"

module RushCalc
  # 技能・仲間突破
  class RootBox
    # コストが大きいものから計算
    TICKET_COURSES = [
      { cost: 800, course: 999, level: 15 },
      { cost: 30, course: 35, level: 1 },
      { cost: 15, course: 15, level: 1 },
    ].freeze

    STONE_COURSES = [
      { cost: 16_000, course: 999, level: 15 },
      { cost: 600, course: 35, level: 1 },
      { cost: 300, course: 15, level: 1 },
    ].freeze

    def initialize(ticket, stone, level)
      @ticket = ticket
      @stone = stone
      @level = level
    end

    def calc_by_cost(courses, cost)
      result = {
        total_draw_count: 0,
        total_cost: 0,
        draw_count_by_course: {},
      }

      courses.each do |course|
        # レベルが足りていなければスキップ
        next if @level < course[:level]

        draw_count = ((cost - result[:total_cost]) / course[:cost]).floor

        result[:draw_count_by_course][course[:course]] = draw_count
        result[:total_draw_count] += draw_count * course[:course]
        result[:total_cost] += draw_count * course[:cost]
      end

      result
    end

    def calc_by_draw_count(courses, draw_count)
      result = {
        total_draw_count: 0,
        total_cost: 0,
        draw_count_by_course: {},
      }

      courses.each do |course|
        # レベルが足りていなければスキップ
        next if @level < course[:level]

        count = ((draw_count - result[:total_draw_count]) / course[:course]).floor

        result[:draw_count_by_course][course[:course]] = count
        result[:total_cost] += count * course[:cost]
        result[:total_draw_count] += count * course[:course]
      end

      result
    end
  end
end

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
end

module RushView
  class RootBox < View
    def initialize
      super
      add_calc_btn_event
    end

    def ticket_num
      document.getElementById("ticket_num")[:value].to_i
    end

    def stone_num
      document.getElementById("stone_num")[:value].to_i
    end

    def level
      document.getElementById("level")[:checked].to_s == "true" ? 15 : 1
    end

    def targets
      1.upto(3).map do |i|
        document.getElementById("goal-#{i}")[:value].to_i
      end
    end

    def calculator
      RushCalc::RootBox.new(ticket_num, stone_num, level)
    end

    def init_result
      @total_draw_count = 0
      @calculator = calculator
      result = document.getElementById("result")
      result[:innerText] = ""

      result
    end

    def add_calc_btn_event
      button = document.getElementById("calc_btn")
      button.addEventListener("click") do
        result = init_result

        create_result(result)
        create_target(result, @total_draw_count)
      end
    end

    def create_result(parent)
      content = create_elem("div", parent) do |div|
        div[:className] = "card-content"
      end

      create_elem("span", content) do |span|
        span[:className] = "card-title"
        span[:innerText] = "計算結果"
      end

      ticket_result = @calculator.calc_by_cost(RushCalc::RootBox::TICKET_COURSES, ticket_num)
      stone_result = @calculator.calc_by_cost(RushCalc::RootBox::STONE_COURSES, stone_num)

      table = create_elem("table", content)
      tbody = create_elem("tbody", table)

      {
        "チケット" => ticket_result,
        "ダイヤ" => stone_result,
      }.each_pair do |item_name, result|
        tr = create_elem("tr", tbody)

        create_elem("td", tr) do |td|
          td[:innerText] = item_name
        end

        create_elem("td", tr) do |td|
          td[:innerText] = result[:draw_count_by_course].map do |(course, times)|
            "#{course}: #{delimited(times)}回（合計: #{delimited(course * times)}）"
          end.join("\n")
        end

        create_elem("td", tr) do |td|
          td[:innerText] = "#{delimited(result[:total_draw_count])}回"
        end
      end

      total_tr = create_elem("tr", tbody)
      create_elem("td", total_tr) do |td|
        td[:innerText] = "合計"
      end

      create_elem("td", total_tr) do |td|
        td[:id] = "total-draw-count"
        td[:colspan] = 2
        @total_draw_count = ticket_result[:total_draw_count] + stone_result[:total_draw_count]
        td[:innerText] = "#{delimited(@total_draw_count)}回"
      end
    end

    def create_target(parent, total_draw_count)
      content = create_elem("div", parent) do |div|
        div[:className] = "card-content"
      end

      create_elem("span", content) do |span|
        span[:className] = "card-title"
        span[:innerText] = "目標"
      end

      table = create_elem("table", content)
      thead = create_elem("thead", table)

      create_elem("tr", thead) do |tr|
        %w[# 消化数 差分 必要アイテム数].each do |text|
          create_elem("th", tr) do |th|
            th[:innerText] = text
          end
        end
      end

      tbody = create_elem("tbody", table)
      targets.each_with_index do |target, i|
        tr = create_elem("tr", tbody)

        create_elem("td", tr) do |td|
          td[:innerText] = "目標#{i + 1}"
        end

        create_elem("td", tr) do |td|
          td[:innerText] = delimited(target) if target.positive?
        end

        create_elem("td", tr) do |td|
          td[:innerText] = delimited(@total_draw_count - target).to_s if target.positive?
        end

        create_elem("td", tr) do |td|
          next if target <= 0

          diff_count = (total_draw_count - target).abs

          ticket_result = @calculator.calc_by_draw_count(RushCalc::RootBox::TICKET_COURSES, diff_count)
          stone_result = @calculator.calc_by_draw_count(RushCalc::RootBox::STONE_COURSES, diff_count)

          text = [
            ["チケット", ticket_result, RushCalc::RootBox::TICKET_COURSES[-1]],
            ["ダイヤ", stone_result, RushCalc::RootBox::STONE_COURSES[-1]],
          ].each_with_object([]) do |(item_name, result, min_course), texts|
            fraction = diff_count - result[:total_draw_count]
            cost = result[:total_cost]
            count = result[:total_draw_count]

            if fraction.positive?
              cost += min_course[:cost]
              count += min_course[:course]
              result[:draw_count_by_course][min_course[:course]] += 1
            end

            texts << "#{item_name}: #{delimited(cost)} （#{delimited(count)}回分）"
            texts << "┗#{result[:draw_count_by_course]}"
          end.join("\n")

          td[:innerText] = text
        end
      end
    end
  end
end



RushView::RootBox.new
