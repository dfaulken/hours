class Shift < ApplicationRecord
  validates :start, :length, presence: true
  validate :valid_chunk

  scope :in_week_beginning, -> (date) { where start: date..(date + 1.week) }

  def self.chunkify
    Hash[all.map{ |shift| [shift.chunkify, shift] }]
  end

  def self.earliest_start
    pluck(:start).map(&:seconds_since_midnight).min.to_i / 60 / 15
  end

  def self.latest_end
    all.map do |shift|
      (shift.start + (60 * shift.length).minutes).seconds_since_midnight
    end.max.to_i / 60 / 15
  end

  def self.lengths
    weekly_totals = { 'MBTA' => 0.0, 'PVTA' => 0.0 }
    totals = all.group_by(&:date).each_pair.map do |date, shifts|
      daily_totals = shifts.group_by(&:mbta?).each_pair.map do |mbta, daily_shifts|
        type = mbta ? 'MBTA' : 'PVTA'
        weekly_totals[type] += daily_shifts.sum(&:length)
        [type, daily_shifts.sum(&:length)]
      end
      [date, Hash[daily_totals]]
    end
    totals << [:week, weekly_totals]
    Hash[totals]
  end

  def chunkify
    (0...(length * 4)).to_a.map do |n|
      start + (15 * n).minutes
    end
  end

  def date
    start.to_date
  end

  private

  def valid_chunk
    unless [0, 15, 30, 45].include? start.min
      errors.add :start, 'must be at a 15-minute interval'
    end
    unless [1, 2, 4].include? length.to_r.denominator
      errors.add :length, 'must be a multiple of 0.25'
    end
  end
end
