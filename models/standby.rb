class Standby
  Type = Struct.new(:name, :hours_weekday, :hours_weekend) do
    def hours(wday)
      if wday==6 || wday==0
        hours_weekend
      else
        hours_weekday
      end
    end
  end

  Early = Type.new('Früh',  8..10, 10..13)
  Late  = Type.new('Spät', 17..19, 13..16)

  attr_reader :date, :type

  def initialize(date, type: Late)
    @date = date
    @type = type
  end

  def ical_event
    e = Icalendar::Event.new
    e.summary = "Cosmo Bereitschaft (#{type.name})"
    e.dtstart = dt type.hours(date.wday).begin
    e.dtend   = dt type.hours(date.wday).end
    e.alarm do |a|
      a.action  = "DISPLAY" # This line isn't necessary, it's the default
      a.trigger = "-P1DT0H0M0S" # 1 day before
    end
    e
  end

  private

  def dt(hour)
    Time.new(date.year, date.month, date.day, hour, 0, 0)
  end
end
