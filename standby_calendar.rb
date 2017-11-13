require "roda"
require "date"
require "icalendar"
require "./models/month"
require "./models/standby"

class StandbyCalendar < Roda
  plugin :render
  plugin :not_found
  
  not_found do
    "Oh, snap!"
  end
  
  route do |r|
    r.root do
      d = Date.today
      r.redirect "/#{d.year}/#{d.month}"
    end

    r.on Integer, Integer do |year, month|
      @month = Month.new(year, month)
      
      r.get do
        view("calendar")
      end

      r.post do
        r.redirect(@month.to_url) unless r['standby']

        calendar = Icalendar::Calendar.new
        calendar.timezone.tzid = "Europe/Berlin"

        r['standby'].each do |mday, values|
          date = @month.day(mday)

          values.each do |type, _|
            standby = Standby.new(date, type: Standby.const_get(type))
            calendar.add_event(standby.ical_event)
          end
        end

        response['Content-Type'] = 'text/calendar'
        response['Content-Disposition'] = "inline; filename=cosmo-bereitschaft-#{@month}"
        calendar.to_ical

      end
    end
  end
end
