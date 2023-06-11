class Availability
  def initialize(paras = {})
    @date = paras[:date]
    @slots = []
  end

  def to_h
    { 'date': @date, 'slots': @slots }
  end
end
