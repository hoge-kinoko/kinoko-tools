# プロジェクト全体で使用するグローバル定数
module KinokoTools
  module Constants
    # ローカルストレージキー（全ツール共通）
    # プレフィックス "kinoko_tools_" で名前空間を確保
    STORAGE_KEYS = {
      # クイズツール関連
      quiz_statistics: "kinoko_tools_quiz_statistics",
      quiz_sessions: "kinoko_tools_quiz_sessions",

      # 突破計算機関連（将来の機能拡張用）
      # rush_calc_settings: "kinoko_tools_rush_calc_settings",
      # rush_calc_history: "kinoko_tools_rush_calc_history",

      # 共通設定（将来の機能拡張用）
      # user_preferences: "kinoko_tools_user_preferences",
      # theme_settings: "kinoko_tools_theme_settings",
      # performance_data: "kinoko_tools_performance_data",
    }.freeze

    # 共通UIメッセージ
    COMMON_MESSAGES = {
      loading_error: "データの読み込みに失敗しました。ページを再読み込みしてください。",
      save_error: "データの保存に失敗しました。",
      reset_confirm: "本当にリセットしますか？この操作は取り消せません。",
      reset_success: "リセットが完了しました。",
    }.freeze

    # アプリケーション情報
    APP_INFO = {
      name: "きのでんツール集",
      version: "1.0.0",
      description: "キノコ伝説プレイヤー向けのWebツール集",
    }.freeze
  end
end
