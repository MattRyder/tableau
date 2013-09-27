module Tableau
  class UriBuilder

    def defaults
      @options = {
        root:               'crwnmis3.staffs.ac.uk/Reporting/',
        timetable_type:     'Individual',
        lookup_type:        'Student+Sets',
        timetable_template: 'Design+Template',
        weeks:              '10-25',                        # 10-25 for Semester 1, 26-42 for Semester 2
        days:               '1-5',                          # Mon - Fri
        period_from:        '5',                            # 15 min intervals since 8AM
        period_to:          '52',
        optional_params:    '&width=0&height=0'             #optional params
      }
    end

    def initialize(lookup_id, options = {})
      @lookup_id = lookup_id
      defaults.merge!(options)

      if options[:module_lookup]
        @options[:lookup_type] = "Modules"
        @options[:timetable_template] = "Module%20Individual%20SOC"
      end

      @options[:weeks] = ENV["TABLEAU_SEMESTER"] == "1" ? '10-25' : '26-42'
    end

    def read
      open(self.to_s){ |io| io.read }
    end

    def to_s
      "http://#{@options[:root]}#{@options[:timetable_type]};#{@options[:lookup_type]};name;" +
      "#{@lookup_id}?&template=#{@options[:timetable_template].gsub(' ', '%20')}" +
      "&weeks=#{@options[:weeks]}&days=#{@options[:days]}" +
      "&periods=#{@options[:period_from]}-#{@options[:period_to]}" +
      "#{@options[:optional_params]}"
    end

  end
end