class JourneyLog
  def initialize(journey_class:)
    @journey_class = journey_class
    @journeys = []
  end

  def start(entry_station)
    current_journey.entry_station = entry_station
  end

  def finish(exit_station)
    current_journey.exit_station = exit_station
  end

  def journeys
    @journeys.dup
  end

  def current_journey
    unless @current_journey
      @current_journey = @journey_class.new
      @journeys << @current_journey
    end
    @current_journey
  end

end
