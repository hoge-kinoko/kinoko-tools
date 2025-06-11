module Quiz
  # クイズツール固有の定数
  module Constants
    # セッション設定
    SESSION_SIZE = 10
    RECORDS_LIMIT = 50
    DISPLAY_SESSIONS_LIMIT = 10

    # UI設定
    GOOD_SCORE_THRESHOLD = 70

    # Grade設定
    GRADE_EXCELLENT = 90..100
    GRADE_GOOD = 70..89
    GRADE_FAIR = 50..69

    # アニメーション設定
    ANIMATION_DELAYS = (0.1..1.0).step(0.1).to_a.freeze

    # クイズ固有メッセージ
    MESSAGES = {
      no_records: "まだ記録がありません",
      empty_answer: "回答を入力してください",
      placeholder: "？？？？",
    }.freeze

    # グレード設定
    GRADE_CONFIG = {
      excellent: { text: "素晴らしい！", class: "excellent" },
      good: { text: "よくできました", class: "good" },
      fair: { text: "もう少し", class: "fair" },
      poor: { text: "頑張りましょう", class: "poor" },
    }.freeze
  end
end
