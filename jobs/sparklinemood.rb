require "httparty"
require "json"

points = []
moods = []
teamApiKey = "PLACE YOUR TEAMMOOD API KEY HERE"
teamMooodApiUrl = "http://app.teammood.com/api/" + teamApiKey + "/moods?since=60"

moodClasses = ["none", "icon-sad", "icon-wondering", "icon-neutral", "icon-smiley", "icon-happy"]

@weekDay = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"]
@weekDayAbbr = ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"]
@monthName = ["Janvier", "Fevrier", "Mars", "Avril", "Mai", "Juin", "Juillet", "Aout", "Septembre", "Octobre", "Novembre", "Decembre"]
@monthNameAbbr = ["Jan", "Fev", "Mar", "Avr", "Mai", "Juin", "Juil", "Aou", "Sept", "Oct", "Nov", "Dec"]

def formatFrenchDate(date)
  return @weekDayAbbr[date.cwday-1] + " " + date.day.to_s + " " + @monthNameAbbr[date.month-1] + " " + date.year.to_s
end

def buildAverage(moodsData)
    dayMood = 0
    nbMoods = 0
    avgMood = 0

    moodsData.each do |mood|
        dayMood = mood["mood"]
        nbMoods = nbMoods + 1

        if dayMood == "excellent"
            avgMood = avgMood + 5
        elsif dayMood == "good"
            avgMood = avgMood + 4
        elsif dayMood == "average"
            avgMood = avgMood + 3
        elsif dayMood == "hard"
            avgMood = avgMood + 2
        elsif dayMood == "bad"
            avgMood = avgMood + 1
        end
    end

    average = ((avgMood + 0.0) / nbMoods).round(2)
    # puts "Sparlinemood - average = " + average.to_s + " - Nb Mood = " + nbMoods.to_s + " - Total = " + avgMood.to_s

    return average
end




SCHEDULER.every '15s' do
  maxPoints = 15
  factor = 10
  moodDatas = {}

  # Get moods from TeamMood
  response = HTTParty.get(teamMooodApiUrl, :verify => false)
  moodDatas = JSON.parse(response.body)

  # Get last mood day
  day = moodDatas["days"][0]["date"]

  moods = []
  # For the last days with moods, compute mood average
  nbDays = moodDatas["days"].count
  min = nbDays < maxPoints ? nbDays-1 : maxPoints-1
  min.step(0, -1) { |i|
    averageMood = buildAverage(moodDatas["days"][i]["values"])
    moods << { x: maxPoints-i, y: averageMood*factor, date: formatFrenchDate(Date.parse(moodDatas["days"][i]["date"])), average: averageMood}
  }

  todayIdx = moods.count-1
  todayMoodLevel = moods[todayIdx][:average].to_i
  yesterdayMoodLevel = moods[todayIdx-1][:average].to_i
  todayMoodImage = moodClasses[todayMoodLevel]
  yesterdayMoodImage = moodClasses[yesterdayMoodLevel]

  moodMessage = "du " +  moods[0][:date] + " au " + moods[todayIdx][:date]

  send_event("sparklinemood", {level: todayMoodLevel, currenticon: todayMoodImage, lasticon: yesterdayMoodImage, moreinfo: moodMessage, points: moods})
end
