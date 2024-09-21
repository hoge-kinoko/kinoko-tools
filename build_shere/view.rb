module BuildShare
  class View < View
    def initialize
      super

      create_option_skill
    end

    def create_option_skill
      skills = Skill.all
      1.upto(5) do |i|
        select = document.getElementById("skill-select-#{i}")
        create_elem("option", select) do |option|
          option.setAttribute("disabled", "")
          option.setAttribute("value", "")
          option.setAttribute("selected", "")
          option[:innerText] = "技能を選択"
        end
        skills.each do |skill|
          create_elem("option", select) do |option|
            option[:value] = ""
            option.setAttribute("data-icon", "../images/skill_icon/#{skill.image_path}")
            option[:className] = "left"
            option[:innerText] = skill.name
          end
        end
      end
    end
  end
end
