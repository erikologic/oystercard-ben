class Journey
  attr_accessor :entry_station, :exit_station

  MIN_FARE = 1
  PENALTY_FARE = 6

  # def initialize(entry_station = nil)
  #   @entry_station = entry_station
  # end

  def fare
    entry_zone = entry_station ? entry_station.zone : 0
    exit_zone = exit_station ? exit_station.zone : 0
    zones = 1 + (entry_zone - exit_zone).abs
    complete? ? MIN_FARE * (zones) : PENALTY_FARE
  end

  # def finish(exit_station = nil)
  #    @exit_station = exit_station
  # end

  def complete?
    !!(@entry_station and @exit_station)
  end
end
