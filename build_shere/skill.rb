class Skill
  attr_reader :id, :rarity, :name, :require_point, :efficacy_duration, :act_duration, :image_path

  def initialize(id:, rarity:, name:, require_point:, efficacy_duration:, act_duration:)
    @id = id
    @rarity = rarity
    @name = name
    @require_point = require_point
    @efficacy_duration = efficacy_duration
    @act_duration = act_duration
    @image_path = "#{id}.png"
  end

  def self.all
    @skills ||= data.map do |skill_data|
      new(
        id: skill_data[:id].to_i,
        rarity: skill_data[:rarity_name].to_sym,
        name: skill_data[:skill_name],
        require_point: skill_data[:require_point].to_i,
        efficacy_duration: skill_data[:efficacy_duration].to_i,
        act_duration: skill_data[:act_duration].to_i,
      )
    end
  end

  def self.find_by_id(id)
    all.find { |skill| skill.id == id }
  end

  def self.find_by_name(name)
    all.find { |skill| skill.name == name }
  end

  def self.select_by_rarity(rarity)
    all.select { |skill| skill.rarity == rarity }
  end

  def self.data
    [
      {
        id: "1",
        rarity_name: "UR",
        rarity_color: "pink",
        skill_name: "稲妻奇襲",
        require_point: "24",
        efficacy_duration: "0",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "2",
        rarity_name: "UR",
        rarity_color: "pink",
        skill_name: "利刃貫通",
        require_point: "19",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "3",
        rarity_name: "UR",
        rarity_color: "pink",
        skill_name: "分身攻撃",
        require_point: "29",
        efficacy_duration: "0",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "4",
        rarity_name: "UR",
        rarity_color: "pink",
        skill_name: "百斬千鎖",
        require_point: "19",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "5",
        rarity_name: "UR",
        rarity_color: "pink",
        skill_name: "風神の矢",
        require_point: "19",
        efficacy_duration: "0",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "6",
        rarity_name: "UR",
        rarity_color: "pink",
        skill_name: "血月降臨",
        require_point: "8",
        efficacy_duration: "0",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "7",
        rarity_name: "UR",
        rarity_color: "pink",
        skill_name: "竜吟双声",
        require_point: "15",
        efficacy_duration: "0",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "8",
        rarity_name: "UR",
        rarity_color: "pink",
        skill_name: "天下の罠",
        require_point: "24",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "9",
        rarity_name: "UR",
        rarity_color: "pink",
        skill_name: "タロット星陣",
        require_point: "24",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "10",
        rarity_name: "LR",
        rarity_color: "red",
        skill_name: "武装解除",
        require_point: "16",
        efficacy_duration: "0",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "11",
        rarity_name: "LR",
        rarity_color: "red",
        skill_name: "眩暈失神",
        require_point: "19",
        efficacy_duration: "0",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "12",
        rarity_name: "LR",
        rarity_color: "red",
        skill_name: "煙幕弾",
        require_point: "13",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "13",
        rarity_name: "LR",
        rarity_color: "red",
        skill_name: "無常狩命",
        require_point: "9",
        efficacy_duration: "0",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "14",
        rarity_name: "LR",
        rarity_color: "red",
        skill_name: "英魂降臨",
        require_point: "19",
        efficacy_duration: "0",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "15",
        rarity_name: "LR",
        rarity_color: "red",
        skill_name: "狂風通道",
        require_point: "16",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "16",
        rarity_name: "SSR",
        rarity_color: "orange",
        skill_name: "ドリ爆弾",
        require_point: "18",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "17",
        rarity_name: "SSR",
        rarity_color: "orange",
        skill_name: "反則打撃",
        require_point: "15",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "18",
        rarity_name: "SSR",
        rarity_color: "orange",
        skill_name: "速度緩慢",
        require_point: "12",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "19",
        rarity_name: "SSR",
        rarity_color: "orange",
        skill_name: "コイン爆弾",
        require_point: "13",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "20",
        rarity_name: "SSR",
        rarity_color: "orange",
        skill_name: "スライ弾",
        require_point: "13",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "21",
        rarity_name: "SSR",
        rarity_color: "orange",
        skill_name: "流星落弾",
        require_point: "13",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "22",
        rarity_name: "SR",
        rarity_color: "yellow",
        skill_name: "蝙蝠行方",
        require_point: "15",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "23",
        rarity_name: "SR",
        rarity_color: "yellow",
        skill_name: "大地回復",
        require_point: "25",
        efficacy_duration: "0",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "24",
        rarity_name: "SR",
        rarity_color: "yellow",
        skill_name: "菌バリア",
        require_point: "19",
        efficacy_duration: "10",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "25",
        rarity_name: "HR",
        rarity_color: "purple",
        skill_name: "落パイン",
        require_point: "11",
        efficacy_duration: "0",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "26",
        rarity_name: "HR",
        rarity_color: "purple",
        skill_name: "貝恩返し",
        require_point: "11",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "27",
        rarity_name: "HR",
        rarity_color: "purple",
        skill_name: "ツタ繁茂",
        require_point: "11",
        efficacy_duration: "0",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "28",
        rarity_name: "R",
        rarity_color: "blue",
        skill_name: "ツタ縛り",
        require_point: "8",
        efficacy_duration: "0",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "29",
        rarity_name: "R",
        rarity_color: "blue",
        skill_name: "疾駆菌茸",
        require_point: "14",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "30",
        rarity_name: "R",
        rarity_color: "blue",
        skill_name: "蜘蛛の巣",
        require_point: "10",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "31",
        rarity_name: "HN",
        rarity_color: "green",
        skill_name: "巨石衝撃",
        require_point: "12",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "32",
        rarity_name: "HN",
        rarity_color: "green",
        skill_name: "トゲ茂み",
        require_point: "8",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "33",
        rarity_name: "HN",
        rarity_color: "green",
        skill_name: "キノ先駆",
        require_point: "14",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "34",
        rarity_name: "N",
        rarity_color: "white",
        skill_name: "胞子爆弾",
        require_point: "7",
        efficacy_duration: "0",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "35",
        rarity_name: "N",
        rarity_color: "white",
        skill_name: "菌茸頭打",
        require_point: "9",
        efficacy_duration: "0",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "36",
        rarity_name: "N",
        rarity_color: "white",
        skill_name: "胞子連撃",
        require_point: "7",
        efficacy_duration: "0",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "37",
        rarity_name: "発動技",
        rarity_color: "orange",
        skill_name: "一面葈耳",
        require_point: "5?",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "38",
        rarity_name: "発動技",
        rarity_color: "orange",
        skill_name: "自然摂理",
        require_point: "5?",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "39",
        rarity_name: "発動技",
        rarity_color: "orange",
        skill_name: "隕石衝突",
        require_point: "5?",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "40",
        rarity_name: "発動技",
        rarity_color: "orange",
        skill_name: "万剣帰宗",
        require_point: "5?",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "41",
        rarity_name: "発動技",
        rarity_color: "orange",
        skill_name: "斧砕千魂",
        require_point: "5?",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "42",
        rarity_name: "発動技",
        rarity_color: "orange",
        skill_name: "鑽心煉骨",
        require_point: "5?",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "43",
        rarity_name: "発動技",
        rarity_color: "orange",
        skill_name: "青羽逐日",
        require_point: "5?",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "44",
        rarity_name: "発動技",
        rarity_color: "orange",
        skill_name: "鶴唳遊鳴",
        require_point: "5?",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
      {
        id: "45",
        rarity_name: "発動技",
        rarity_color: "orange",
        skill_name: "星河入夢",
        require_point: "5?",
        efficacy_duration: "5",
        act_duration: "1",
        skill_image_path: "",
      },
    ]
  end
end
