// TODO: 想定外の法則あったため一回閉じる

function set_s344() {
    //create_schedule()
}

function create_schedule() {
    const schedule_area = document.getElementById("schedule")
    schedule_area.innerHTML = ""
}


class Event {
    static get REGULAR() {
        return {
            1: {
                week_events: ["kirei", "guild_kirei"], // 月~日
                1: [], 2: [], 3: [], 4: [], 5: [], 6: [], 7: [] // 日曜は0
            },
            2: {
                week_events: ["kenkyu"],
                1: [], 2: ["kijou"], 3: ["kijou"], 4: [], 5: [], 6: [], 7: []
            },
            3: {
                week_events: ["bukon"],
                1: [], 2: ["nakama"], 3: ["nakama"], 4: [], 5: [], 6: [], 7: []
            },
            4: {
                week_events: ["ibutu"],
                1: [], 2: ["ginou"], 3: ["ginou"], 4: [], 5: [], 6: [], 7: []
            },
        }
    }

    static get BEGINNER() {
        return {
            1: ["stage"], 2: ["stage"], 3: ["kirei"], 4: ["kirei"], 5: ["kirei"], 6: ["kirei"], 7: ["kirei"],
            8: ["kenkyu"], 9: ["kenkyu", "kijou"], 10: ["kenkyu", "kijou"], 11: ["kenkyu"], 12: ["kenkyu"], 13: ["kenkyu"], 14: ["kenkyu"],
            15: ["bukon"], 16: ["bukon", "nakama"], 17: ["bukon", "nakama"], 18: ["bukon"], 19: ["bukon"], 20: ["bukon"], 21: ["bukon"],
            22: ["ibutu"], 23: ["ibutu", "ginou"], 24: ["ibutu", "ginou"], 25: ["ibutu"], 26: ["ibutu"], 27: ["ibutu"], 28: ["ibutu"]
        }
    }

    static get SETTINGS() {
        return {
            "stage":       { name: "ステージ突破", color: "orange" },
            "kirei":       { name: "祈霊突破",     color: "blue" },
            "guild_kirei": { name: "菌属祈霊",     color: "grey" },
            "kenkyu":      { name: "研究突破",     color: "purple" },
            "kijou":       { name: "騎乗突破",     color: "indigo" },
            "bukon":       { name: "武魂突破",     color: "teal" },
            "nakama":      { name: "仲間突破",     color:"lime" },
            "ginou":       { name: "技能突破",     color: "red" },
            "ibutu":       { name: "遺物突破",     color: "cyan" }
        }
    }
}

class Schedule {
    static get MILESTONE() { return 28 }

    constructor(start_date_str) {
        this.start_date = this.trim_date(start_date_str)
        this.today = this.trim_date(new Date())
        this.period_days = Math.ceil((this.today - this.start_date) / 86400000)
        this.milestone_date = this.calc_milestone_date(this.start_date)
        this.normal_event_offset = this.calc_normal_event_offset()
        this.normal_event_start_date = this.calc_normal_event_start_date()
        this.is_biginner = this.period_days <= 28
    }

    trim_date(date_str) {
        const date = new Date(date_str)
        return new Date(date.getFullYear(), date.getMonth(), date.getDate())
    }

    adjustedDay(date) {
        const day = date.getDay()
        return day === 0 ? 7 : day
    }

    format_date(date) {
        const day = ["月", "火", "水", "木", "金", "土", "日" ][this.adjustedDay(date)]
        return `${date.toLocaleDateString('sv-SE')}(${day})`
    }

    calc_milestone_date() {
        let date = new Date(this.start_date.getTime())
        date.setDate(this.start_date.getDate() + Schedule.MILESTONE)

        return this.trim_date(date)
    }

    calc_normal_event_offset() {
        const milestone_day = this.adjustedDay(this.milestone_date)
        if(milestone_day === 1) {
            return 0
        }

        return (8 - milestone_day) % 7
    }

    calc_normal_event_start_date() {
        let date = new Date(this.milestone_date.getTime())
        date.setDate(this.milestone_date.getDate() + this.normal_event_offset)

        return date
    }
}
