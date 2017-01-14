require 'journey'
require 'journeylog'

class Oystercard
attr_reader :balance, :journeylog
attr_accessor :journey

MAX_LIMIT = 90

  def initialize(journeylog = JourneyLog.new(journey_class: Journey))
    @balance = 0
    @journeylog = journeylog
  end

  def top_up(money)
    message = "Limit of #{MAX_LIMIT} exceeded, can not top up the card."
    raise message if @balance + money > MAX_LIMIT
    @balance += money
  end


  def touch_in(entry_station)
    message = "Insufficient funds. Must top up card."
    raise message if balance < Journey::MIN_FARE
    @journeylog.start(entry_station)
  end

  def touch_out(exit_station)
    @journeylog.finish(exit_station)
    deduct(@journeylog.current_journey.fare)
  end

  def entry_station
    @journeylog.current_journey.entry_station
  end

  def exit_station
    @journeylog.current_journey.exit_station
  end

private
    def deduct(money)
      @balance -= money
    end

end
