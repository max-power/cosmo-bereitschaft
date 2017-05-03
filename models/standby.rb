class Standby
  Type  = Struct.new(:name, :h_start, :h_end)
  Early = Type.new('Früh',  8, 10)
  Late  = Type.new('Spät', 17, 19)
  
  attr_reader :date, :type
  
  def initialize(date, type: Late)
    @date = date
    @type = type
  end
  
  def ical_event
    e = Icalendar::Event.new
    e.summary = "Cosmo Bereitschaft (#{type.name})"
    e.dtstart = DateTime.new(date.year, date.month, date.day, type.h_start, 0, 0)
    e.dtend   = DateTime.new(date.year, date.month, date.day, type.h_end, 0, 0)
    e.alarm do |a|
      a.action  = "DISPLAY" # This line isn't necessary, it's the default
      a.trigger = "-P1DT0H0M0S" # 1 day before
    end
    e
  end
end
