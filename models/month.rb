require 'date'

class Month
  include Comparable
  
  def self.from(obj)
    unless obj.respond_to?(:year) && obj.respond_to?(:month)
      raise ArgumentError.new("Argument doesn't respond to 'year' or 'month'")
    else
      new(obj.year, obj.month)
    end
  end

  def self.now
    from Time.now
  end

  attr_reader :year, :month

  def initialize(year, month)
    @year  = Integer(year)
    @month = Integer(month).clamp(1, 12)
  end
  
  def each_day(&block)
    days.each(&block)
  end

  def days
    first_day..last_day
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

  def day(mday)
    days.to_a[mday - 1]
  end

  def succ
    self.class.from(last_day + 1)
  end

  def pred
    self.class.from(first_day - 1)
  end
  
  def name
    "#{month_name} #{year}"
  end

  def month_name
    Date::MONTHNAMES[month]
  end
  
  def month_abbr
    Date::ABBR_MONTHNAMES[month]
  end
  
  def to_s(sep='-')
    "#{year}#{sep}#{month}"
  end

  def to_path
    "/#{year}/#{month}"
  end

  def to_url
    to_path
  end
  
  def <=>(other)
    (year <=> other.year).nonzero? || month <=> other.month
  end

  alias_method :next, :succ
  alias_method :prev, :pred
  alias_method :end,   :last_day
  alias_method :begin, :first_day
end

