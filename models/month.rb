require 'date'

class Month
  attr_reader :year, :month

  def initialize(year, month)
    @year  = Integer(year)
    @month = Integer(month).clamp(1, 12)
  end

  def days
    first_day..last_day
  end
  
  def each_day(&block)
    days.each(&block)
  end

  def number_of_days
    last_day.day
  end

  def first_day
    Date.new(year, month, 1)
  end

  def last_day
    Date.new(year, month, -1)
  end

  def to_s(sep='-')
    "#{year}#{sep}#{month}"
  end

  def to_url
    "/#{to_s('/')}"
  end

  def name
    "#{month_name} #{year}"
  end

  def month_name
    Date::MONTHNAMES[month]
  end

  def day(mday)
    d = mday.clamp(1, number_of_days)
    Date.new(year, month, d)
  end

  alias_method :begin, :first_day
  alias_method :end,   :last_day

  def next
    d = last_day + 1
    self.class.new(d.year, d.month)
  end

  def prev
    d = first_day - 1
    self.class.new(d.year, d.month)
  end

  def ==(other)
    year == other.year && month == other.month
  end
end
