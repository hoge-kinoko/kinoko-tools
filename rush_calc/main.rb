require "js"

class EventCalc
  # TODO: これ使うようにしたい
  # コストが大きいものから計算
  ticket_courses = [
    { cost: 800, draw_count: 999 },
    { cost: 30, draw_count: 35 },
  ].freeze

  stone_courses = [
    { cost: 600, draw_count: 35 },
  ]

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

  def calc_by_ticket
    course_999 = (ticket_num / 800).floor * 999
    course_35 = ((ticket_num % 800) / 30).floor * 35

    course_999 + course_35
  end

  def calc_by_stone
    (stone_num / 600).floor * 35
  end

  def add_calc_event
    button = document.getElementById("calc_btn")
    button.addEventListener("click") do
      result = document.getElementById("result")
      result[:innerText] = ""

      document.createElement("span").tap do |span|
        span[:className] = "card-title"
        span[:innerText] = "計算結果"
        result.appendChild(span)
      end

      document.createElement("table").tap do |table|
        document.createElement("tbody").tap do |tbody|
          [["チケット", calc_by_ticket], ["ダイヤ", calc_by_stone], ["合計", calc_by_ticket + calc_by_stone]].each do |content|
            document.createElement("tr").tap do |tr|
              document.createElement("td").tap do |td|
                td[:innerText] = content[0]
                tr.appendChild(td)
              end
              document.createElement("td").tap do |td|
                td[:innerText] = "#{content[1].to_s.reverse.scan(/.{1,3}/).join(",").reverse}回"
                tr.appendChild(td)
              end
              tbody.appendChild(tr)
            end
          end
          table.appendChild(tbody)
        end

        result.appendChild(table)
      end
    end
  end
end

EventCalc.new
