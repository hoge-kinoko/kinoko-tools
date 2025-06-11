require "js"
require "json"

module Quiz
  # 統計記録を管理するクラス
  class Statistics
    def initialize
      @current_session = []
      @records = load_records
      @sessions = load_sessions
    end

    # 回答を記録
    def record_answer(question, answer, user_answer, is_correct)
      answer_record = {
        question:,
        answer:,
        user_answer:,
        is_correct:,
        timestamp: JS.global[:Date].new.toISOString,
      }

      @current_session << answer_record
      @records << answer_record

      # 上限を超える場合は古い記録を削除
      @records = @records.last(Quiz::Constants::RECORDS_LIMIT) if @records.length > Quiz::Constants::RECORDS_LIMIT

      save_records
    end

    # 現在のセッション結果を取得
    def current_session_result
      return { correct: 0, total: 0, percentage: 0 } if @current_session.empty?

      correct_count = @current_session.count { |record| record[:is_correct] }
      total = @current_session.length
      percentage = total.positive? ? (correct_count.to_f / total * 100).round(1) : 0

      {
        correct: correct_count,
        total:,
        percentage:,
      }
    end

    # 直近50問の正答率を取得
    def overall_statistics
      return { correct: 0, total: 0, percentage: 0 } if @records.empty?

      correct_count = @records.count { |record| record[:is_correct] }
      total = @records.length
      percentage = total.positive? ? (correct_count.to_f / total * 100).round(1) : 0

      {
        correct: correct_count,
        total:,
        percentage:,
      }
    end

    # 直近の記録を取得（最新10件）
    def recent_records(count = 10)
      @records.last(count).reverse
    end

    # 新しいセッションを開始
    def start_new_session
      @current_session = []
    end

    # セッションが完了したかチェック
    def session_completed?
      @current_session.length >= Quiz::Constants::SESSION_SIZE
    end

    # 現在のセッションを完了として記録
    def complete_current_session
      return if @current_session.length != Quiz::Constants::SESSION_SIZE

      session_result = current_session_result
      session_data = {
        timestamp: JS.global[:Date].new.toISOString,
        correct: session_result[:correct],
        total: session_result[:total],
        percentage: session_result[:percentage],
      }

      @sessions << session_data

      # 最新セッションのみ保持
      if @sessions.length > Quiz::Constants::DISPLAY_SESSIONS_LIMIT
        @sessions = @sessions.last(Quiz::Constants::DISPLAY_SESSIONS_LIMIT)
      end

      save_sessions
    end

    # 直近のセッション記録を取得
    def recent_sessions(count = Quiz::Constants::DISPLAY_SESSIONS_LIMIT)
      @sessions.last(count).reverse
    end

    # 全ての記録をリセット
    def reset_all_records
      JS.global[:console].log("リセット開始 - 現在の記録数:", @records.length, "セッション数:", @sessions.length)

      @current_session = []
      @records = []
      @sessions = []

      # LocalStorageからも削除
      begin
        storage = JS.global[:localStorage]
        storage.removeItem(KinokoTools::Constants::STORAGE_KEYS[:quiz_statistics])
        storage.removeItem(KinokoTools::Constants::STORAGE_KEYS[:quiz_sessions])
        JS.global[:console].log("LocalStorage削除完了")

        # 削除確認
        check_key1 = storage.getItem(KinokoTools::Constants::STORAGE_KEYS[:quiz_statistics])
        check_key2 = storage.getItem(KinokoTools::Constants::STORAGE_KEYS[:quiz_sessions])
        JS.global[:console].log("削除確認 - records:", check_key1, "sessions:", check_key2)
      rescue StandardError => e
        JS.global[:console].error("記録削除エラー:", e.message)
        raise e
      end

      JS.global[:console].log("リセット完了 - 記録数:", @records.length, "セッション数:", @sessions.length)
      true
    end

    private

    # LocalStorageから記録を読み込み
    def load_records
      load_data_from_storage(KinokoTools::Constants::STORAGE_KEYS[:quiz_statistics]) do |record_js|
        parse_record(record_js)
      end
    end

    # LocalStorageに記録を保存
    def save_records
      save_data_to_storage(KinokoTools::Constants::STORAGE_KEYS[:quiz_statistics], @records)
    end

    # LocalStorageからセッション記録を読み込み
    def load_sessions
      load_data_from_storage(KinokoTools::Constants::STORAGE_KEYS[:quiz_sessions]) do |session_js|
        parse_session(session_js)
      end
    end

    # LocalStorageにセッション記録を保存
    def save_sessions
      save_data_to_storage(KinokoTools::Constants::STORAGE_KEYS[:quiz_sessions], @sessions)
    end

    # 共通のLocalStorage読み込み処理
    def load_data_from_storage(key, &)
      storage = JS.global[:localStorage]
      json_data = storage.getItem(key)
      return [] if data_empty?(json_data)

      JsonParser.parse_json_array(json_data, &)
    rescue StandardError => e
      log_error("データ読み込みエラー (#{key}):", e)
      []
    end

    # 共通のLocalStorage保存処理
    def save_data_to_storage(key, data)
      storage = JS.global[:localStorage]
      json_data = JS.global[:JSON].stringify(data.to_a)
      storage.setItem(key, json_data)
    rescue StandardError => e
      log_error("データ保存エラー (#{key}):", e)
    end

    # JSONデータが空かチェック
    def data_empty?(json_data)
      json_data.nil? || json_data.to_s == "null"
    end

    # 記録データをパース
    def parse_record(record_js)
      {
        question: record_js[:question].to_s,
        answer: record_js[:answer].to_s,
        user_answer: record_js[:user_answer].to_s,
        is_correct: parse_boolean(record_js[:is_correct]),
        timestamp: record_js[:timestamp].to_s,
      }
    end

    # セッションデータをパース
    def parse_session(session_js)
      {
        timestamp: session_js[:timestamp].to_s,
        correct: session_js[:correct].to_i,
        total: session_js[:total].to_i,
        percentage: session_js[:percentage].to_f,
      }
    end

    # boolean値を正しくパース
    def parse_boolean(value)
      value.to_s == "true" || value == true
    end

    # エラーログ出力
    def log_error(message, error)
      JS.global[:console].error(message, error.message)
    end
  end
end
