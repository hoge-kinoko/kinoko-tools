require "js"

class EventCalc
  # コストが大きいものから計算
  TICKET_COURSES = [
    { cost: 800, course: 999, level: 15 },
    { cost: 30, course: 35, level: 1 },
    { cost: 15, course: 15, level: 1 },
  ].freeze

  STONE_COURSES = [
    { cost: 16_000, course: 999, level: 15},
    { cost: 600, course: 35, level: 1 },
    { cost: 300, course: 15, level: 1 },
  ].freeze

  def initialize
    add_calc_event
  end

  private

  def document
    JS.global["document"]
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
      document.getElementById("target-#{i}")[:value].to_i
    end
  end

  def delimited(n)
    return n.to_s if n.abs.to_s.length <= 3

    n.to_s.reverse.scan(/.{1,3}/).join(",").reverse
  end

  def create_elem(tag, parent)
    elem = document.createElement(tag)

    yield(elem) if block_given?

    parent.appendChild(elem) if parent

    elem
  end

  # result
  # { draw_count_by_course: { 999: 1, 35: 1 }, total_count: 1034, total_cost: 830}
  def calc(courses, point)
    result = {
      total_draw_count: 0,
      total_cost: 0,
      draw_count_by_course: {},
    }

    courses.each do |course|
      # レベルが足りていなければスキップ
      next if level < course[:level]

      draw_count = ((point - result[:total_cost]) / course[:cost]).floor

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
      next if level < course[:level]

      count = ((draw_count - result[:total_draw_count]) / course[:course]).floor

      result[:draw_count_by_course][course[:course]] = count
      result[:total_cost] += count * course[:cost]
      result[:total_draw_count] += count * course[:course]
    end

    result
  end

  def calc_by_stone
    (stone_num / 600).floor * 35
  end

  def create_result_table(parent)
    ticket_result = calc(TICKET_COURSES, ticket_num)
    stone_result = calc(STONE_COURSES, stone_num)

    table = create_elem("table", parent)
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
      td.setAttribute("colspan", "2")
      @total_draw_count = ticket_result[:total_draw_count] + stone_result[:total_draw_count]
      td[:innerText] = "#{delimited(@total_draw_count)}回"
    end
  end

  def create_target_table(parent)
    table = create_elem("table", parent)

    thead = create_elem("thead", table)
    create_elem("tr", thead) do |tr|
      ["#", "消化数", "差分", "必要アイテム数"].each do |text|
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
        next unless target.positive?

        td[:innerText] = delimited(target)
      end

      create_elem("td", tr) do |td|
        next unless target.positive?

        td[:innerText] = "#{delimited(@total_draw_count - target)}"
      end

      create_elem("td", tr) do |td|
        next unless target.positive?

        diff_point = (@total_draw_count - target).abs

        ticket_result = calc_by_draw_count(TICKET_COURSES, diff_point)
        stone_result = calc_by_draw_count(STONE_COURSES, diff_point)

        text = []
        [
          ["チケット",  ticket_result, TICKET_COURSES[-1]],
          ["ダイヤ", stone_result, STONE_COURSES[-1]],
        ].each do |item_name, result, min_course|
          fraction = diff_point - result[:total_draw_count]

          cost = result[:total_cost]
          count = result[:total_draw_count]

          if fraction.positive?
            cost += min_course[:cost]
            count += min_course[:course]
            result[:draw_count_by_course][min_course[:course]] += 1
          end

          text << "#{item_name}: #{delimited(cost)} （#{delimited(count)}回分）"
          text << "┗#{result[:draw_count_by_course]}"
        end

        td[:innerText] = text.join("\n")
      end
    end
  end

  def add_calc_event
    button = document.getElementById("calc_btn")
    button.addEventListener("click") do
      result = document.getElementById("result")
      result[:innerText] = ""

      result_content = create_elem("div", result) do |div|
        div[:className] = "card-content"
      end

      create_elem("span", result_content) do |span|
        span[:className] = "card-title"
        span[:innerText] = "計算結果"
      end
      create_result_table(result_content)

      target_content = create_elem("div", result) do |div|
        div[:className] = "card-content"
      end
      create_elem("span", target_content) do |span|
        span[:className] = "card-title"
        span[:innerText] = "目標"
      end
      create_target_table(target_content)
    end
  end
end

EventCalc.new
