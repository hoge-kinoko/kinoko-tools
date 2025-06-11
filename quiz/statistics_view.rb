require "js"

module Quiz
  # 統計表示を担当するクラス
  class StatisticsView < ::View
    def initialize(statistics, parent_container)
      super()
      @statistics = statistics
      @parent_container = parent_container

      create_statistics_area
    end

    # 統計表示を更新
    def update_display
      update_statistics_content
      update_records_list
    end

    # リザルト表示をクリア
    def clear_result_display
      result_area = document.getElementById("session-result")
      return unless result_area && result_area.to_s != "null"

      result_area[:innerHTML] = ""
      result_area[:className] = "session-result"
    end

    # セッション結果を表示
    def show_session_result
      session_stats = @statistics.current_session_result
      result_area = document.getElementById("session-result")
      return unless result_area

      result_area[:innerHTML] = ""
      result_area[:className] = "session-result completed"

      create_result_card(result_area, session_stats)
    end

    private

    # 統計表示エリアを作成
    def create_statistics_area
      return unless @parent_container && @parent_container.to_s != "null"

      # 統計表示エリア
      stats_area = create_main_stats_area

      # 全体統計
      overall_stats = create_overall_stats_container(stats_area)

      # 記録表示機能
      create_records_section(overall_stats)

      # リセット機能
      create_reset_section(overall_stats)

      # リザルト表示エリア
      create_result_area(stats_area)
    end

    # メインの統計エリアを作成
    def create_main_stats_area
      stats_area = create_elem("div", @parent_container) do |div|
        div[:id] = "statistics-area"
        div[:className] = "statistics-area"
      end

      # クイズコンテナの前に配置
      quiz_element = document.getElementById("quiz")
      @parent_container.insertBefore(stats_area, quiz_element) if quiz_element

      stats_area
    end

    # 全体統計コンテナを作成
    def create_overall_stats_container(parent)
      create_elem("div", parent) do |div|
        div[:id] = "overall-stats"
        div[:className] = "overall-stats"
      end
    end

    # 記録セクションを作成
    def create_records_section(parent)
      # 折りたたみヘッダー
      records_header = create_elem("div", parent) do |div|
        div[:id] = "records-header"
        div[:className] = "records-header"
        div[:innerHTML] = '<i class="material-icons">expand_more</i> 直近の記録'
      end

      # 記録一覧
      create_elem("div", parent) do |div|
        div[:id] = "records-list"
        div[:className] = "records-list collapsed"
      end

      # イベント設定
      records_header.addEventListener("click") do
        toggle_records_visibility
      end
    end

    # リセットセクションを作成
    def create_reset_section(parent)
      reset_controls = create_elem("div", parent) do |div|
        div[:id] = "reset-controls"
        div[:className] = "reset-controls"
      end

      reset_button = create_elem("button", reset_controls) do |btn|
        btn[:id] = "reset-records-button"
        btn[:className] = "reset-records-button"
        btn[:innerHTML] = '<i class="material-icons">delete_forever</i> 記録をリセット'
      end

      reset_button.addEventListener("click") do
        execute_reset
      end
    end

    # リザルト表示エリアを作成
    def create_result_area(parent)
      create_elem("div", parent) do |div|
        div[:id] = "session-result"
        div[:className] = "session-result"
      end
    end

    # 統計コンテンツを更新
    def update_statistics_content
      overall_stats = @statistics.overall_statistics
      overall_element = document.getElementById("overall-stats")

      return unless overall_element && overall_element.to_s != "null"

      stats_content = get_or_create_stats_content(overall_element)
      render_statistics_content(stats_content, overall_stats)
    end

    # 統計コンテンツ要素を取得または作成
    def get_or_create_stats_content(parent)
      stats_content = document.getElementById("stats-content")

      if !stats_content || stats_content.to_s == "null"
        stats_content = create_elem("div", parent) do |div|
          div[:id] = "stats-content"
          div[:className] = "stats-content"
        end

        # 既存の内容の先頭に挿入
        first_child = parent[:firstChild]
        parent.insertBefore(stats_content, first_child) if first_child
      end

      stats_content
    end

    # 統計コンテンツを描画
    def render_statistics_content(element, stats)
      if (stats[:total]).zero?
        render_no_records_message(element)
      else
        render_statistics_summary(element, stats)
      end
    end

    # 記録なしメッセージを描画
    def render_no_records_message(element)
      element[:innerHTML] = <<~HTML
        <h3>📊 全体統計</h3>
        <div class="stats-summary">
          <span class="stat-item">まだ記録がありません</span>
        </div>
      HTML
    end

    # 統計サマリーを描画
    def render_statistics_summary(element, stats)
      element[:innerHTML] = <<~HTML
        <h3>📊 全体統計（直近#{stats[:total]}問）</h3>
        <div class="stats-summary">
          <span class="stat-item">正答率: <strong>#{stats[:percentage]}%</strong></span>
          <span class="stat-item">正解: #{stats[:correct]}問</span>
          <span class="stat-item">不正解: #{stats[:total] - stats[:correct]}問</span>
        </div>
      HTML
    end

    # 記録一覧を更新
    def update_records_list
      records_list = document.getElementById("records-list")
      return unless records_list && records_list.to_s != "null"

      recent_sessions = @statistics.recent_sessions(Quiz::Constants::DISPLAY_SESSIONS_LIMIT)
      records_list[:innerHTML] = ""

      if recent_sessions.empty?
        render_no_records_placeholder(records_list)
      else
        render_session_records(records_list, recent_sessions)
      end
    end

    # 記録なしプレースホルダーを描画
    def render_no_records_placeholder(parent)
      create_elem("p", parent) do |p|
        p[:className] = "no-records"
        p[:innerText] = "まだ記録がありません"
      end
    end

    # セッション記録を描画
    def render_session_records(parent, sessions)
      sessions.each do |session|
        create_elem("div", parent) do |div|
          score_class = session[:percentage] >= Quiz::Constants::GOOD_SCORE_THRESHOLD ? "good-session" : "poor-session"
          div[:className] = "session-item #{score_class}"

          date = JS.global[:Date].new(session[:timestamp])
          formatted_date = date.toLocaleDateString("ja-JP")
          formatted_time = date.toLocaleTimeString("ja-JP", { hour: "2-digit", minute: "2-digit" })

          div[:innerHTML] = <<~HTML
            <div class="session-score">#{session[:correct]}/#{session[:total]}</div>
            <div class="session-percentage">#{session[:percentage]}%</div>
            <div class="session-date">#{formatted_date} #{formatted_time}</div>
          HTML
        end
      end
    end

    # 結果カードを作成
    def create_result_card(parent, session_stats)
      create_elem("div", parent) do |div|
        div[:className] = "result-card"

        create_elem("h3", div) do |h3|
          h3[:innerText] = "🎯 今回の結果"
        end

        create_result_summary(div, session_stats)
      end
    end

    # 結果サマリーを作成
    def create_result_summary(parent, stats)
      create_elem("div", parent) do |summary|
        summary[:className] = "result-summary"

        percentage = stats[:percentage]
        grade = calculate_grade(percentage)

        summary[:innerHTML] = <<~HTML
          <div class="result-score">
            <span class="score-number">#{stats[:correct]}</span>
            <span class="score-total">/#{Quiz::Constants::SESSION_SIZE}問正解</span>
          </div>
          <div class="result-percentage">正答率: #{percentage}%</div>
          <div class="result-grade #{grade[:class]}">#{grade[:text]}</div>
        HTML
      end
    end

    # 成績判定
    def calculate_grade(percentage)
      case percentage
      when Quiz::Constants::GRADE_EXCELLENT
        Quiz::Constants::GRADE_CONFIG[:excellent]
      when Quiz::Constants::GRADE_GOOD
        Quiz::Constants::GRADE_CONFIG[:good]
      when Quiz::Constants::GRADE_FAIR
        Quiz::Constants::GRADE_CONFIG[:fair]
      else
        Quiz::Constants::GRADE_CONFIG[:poor]
      end
    end

    # 記録の表示/非表示を切り替え
    def toggle_records_visibility
      records_list = document.getElementById("records-list")
      records_header = document.getElementById("records-header")
      return unless valid_elements?(records_list, records_header)

      if records_list[:className].to_s.include?("collapsed")
        expand_records(records_list, records_header)
      else
        collapse_records(records_list, records_header)
      end
    end

    # 要素の有効性を確認
    def valid_elements?(*elements)
      elements.all? { |el| el && el.to_s != "null" }
    end

    # 記録を展開
    def expand_records(list, header)
      list[:className] = "records-list expanded"
      header[:innerHTML] = '<i class="material-icons">expand_less</i> 直近の記録'
    end

    # 記録を折りたたみ
    def collapse_records(list, header)
      list[:className] = "records-list collapsed"
      header[:innerHTML] = '<i class="material-icons">expand_more</i> 直近の記録'
    end

    # リセットを実行
    def execute_reset
      @statistics.reset_all_records
      update_display
      clear_result_display
    rescue StandardError => e
      JS.global[:console].error("リセット実行エラー:", e.message)
      show_error("リセットに失敗しました。ページを再読み込みしてください。", "statistics-area")
    end
  end
end
