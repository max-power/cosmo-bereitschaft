require "roda"
require "date"
require "tzinfo"
require "icalendar"
require "icalendar/tzinfo"
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

    r.on ":year/:month" do |year, month|
      @month = Month.new(year, month)
      
      r.get do
        view("calendar")
      end
      
      r.post do
        r.redirect(@month.to_url) unless r['standby']
        
        calendar = Icalendar::Calendar.new
        tzid = "Europe/Berlin"
        tz = TZInfo::Timezone.get tzid
        timezone = tz.ical_timezone DateTime.now
        calendar.add_timezone timezone
                
        r['standby'].each do |day, values|
          date = Date.civil(@month.year, @month.month, Integer(day))

          values.each do |type, _|
            standby = Standby.new(date, type: Standby.const_get(type), tzid: tzid)
            calendar.add_event(standby.ical_event)
          end
        end
      
        response['Content-Type'] = 'text/calendar'
        calendar.to_ical

      end
    end

  end
end