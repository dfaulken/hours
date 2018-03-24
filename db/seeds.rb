def create_default_shifts(week_range)
  week_range.each do |day|
    Shift.create! start: day + 8.5.hours, length: 8.0, mbta: true
    Shift.create! start: day + 16.5.hours, length: 1.0, mbta: false
  end
end

monday = Date.today.beginning_of_week(:monday).to_date
friday = (monday + 4.days).to_date
create_default_shifts(monday..friday)

last_monday = (monday - 1.week).to_date
last_friday = (friday - 1.week).to_date
create_default_shifts(last_monday..last_friday)
