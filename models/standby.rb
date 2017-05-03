class Standby
  Type  = Struct.new(:name, :h_start, :h_end)
  Early = Type.new('Früh',  8, 10)
  Late  = Type.new('Spät', 17, 19)
  
  attr_reader :date, :type, :tzid
  
  def initialize(date, type: Late, tzid: '')
    @date = date
    @type = type
    @tzid = tzid
  end
  
  def ical_event
    e = Icalendar::Event.new
    e.summary = "Cosmo Bereitschaft (#{type.name})"
    e.dtstart = Icalendar::Values::DateTime.new(standby_start, tzid: tzid)
    e.dtend   = Icalendar::Values::DateTime.new(standby_end,   tzid: tzid)
    e.alarm do |a|
      a.action  = "DISPLAY" # This line isn't necessary, it's the default
      a.trigger = "-P1DT0H0M0S" # 1 day before
    end
    e
  end
  
  def standby_start
    DateTime.new(date.year, date.month, date.day, type.h_start, 0, 0)
  end
  
  def standby_end
    DateTime.new(date.year, date.month, date.day, type.h_end, 0, 0)
  end
end
