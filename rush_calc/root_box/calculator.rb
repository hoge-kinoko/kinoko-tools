module RootBox
  class Calculator
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
