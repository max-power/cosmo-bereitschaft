require "roda"
require "date"
require "icalendar"
require "./models/month"
require "./models/standby"

class StandbyCalendar < Roda
  opts[:root] = File.dirname(__FILE__)
  plugin :render
  plugin :not_found
  plugin :public

  not_found do
    "Oh, snap!"
  end

  route do |r|
    r.public
    
    r.root do
      r.redirect Month.now.to_path
    end

    r.on Integer, Integer do |year, month|
      @month = Month.new(year, month)
      
      r.get do
        view("calendar")
      end

      r.post do
        r.redirect(@month.to_url) unless r.params["standby"]

        calendar = Icalendar::Calendar.new
        calendar.timezone.tzid = "Europe/Berlin"

        r.params["standby"].each do |mday, values|
          date = @month.day(mday.to_i)

          values.each do |type, _|
            standby = Standby.new(date, type: Standby.const_get(type))
            calendar.add_event(standby.ical_event)
          end
        end

        response["Content-Type"] = "text/calendar"
        response["Content-Disposition"] = "inline; filename=cosmo-bereitschaft-#{@month}"
        calendar.to_ical

      end
    end
  end
end
