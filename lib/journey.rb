class Journey
  attr_accessor :entry_station, :exit_station

  MIN_FARE = 1
  PENALTY_FARE = 6

  # def initialize(entry_station = nil)
  #   @entry_station = entry_station
  # end

  def fare
    complete? ? MIN_FARE : PENALTY_FARE
  end

  # def finish(exit_station = nil)
  #    @exit_station = exit_station
  # end

  def complete?
    !!(@entry_station and @exit_station)
  end
end
