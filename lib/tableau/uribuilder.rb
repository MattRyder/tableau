module Tableau
  class UriBuilder

    def defaults
      @options = {
        root: 'crwnmis3.staffs.ac.uk/Reporting/',
        timetable_type: 'Individual',
        timetable_template: 'Module%20Individual%20SOC',
        weeks:           '10-25',
        days:            '1-5', # Mon - Fri
        period_from:     '5',  # 15 min intervals since 8AM
        period_to:       '52',
        optional_params: '&width=0&height=0' #optional params
      }
    end

    def initialize(module_id, semester, options = {})
      @module_id = module_id
      defaults.merge!(options)
      @options[:weeks] = semester == 1 ? '10-25' : '26-42'
    end

    def read
      open(self.to_s){ |io| data = io.read }
    end

    def to_s
      "http://#{@options[:root]}#{@options[:timetable_type]};Modules;name;" +
      "#{@module_id}?&template=#{@options[:timetable_template].gsub(' ', '%20')}"+
      "&weeks=#{@options[:weeks]}&days=#{@options[:days]}"+
      "&periods=#{@options[:period_from]}-#{@options[:period_to]}"+
      "#{@options[:optional_params]}"
    end

  end
end