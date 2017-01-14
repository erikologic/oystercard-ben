require 'oystercard'
require 'station'
require 'journey'

describe "User stories" do
  let(:oystercard)  { Oystercard.new }
  let(:entry_station) {Station.new("Bank", 1)}
  let(:exit_station)  {Station.new("Tower Bridge", 1)}

  # In order to use public transport
  # As a customer
  # I want money on my card
  it 'so customer will check money on their card, card will start with balance 0' do
    expect(oystercard.balance).to eq 0
  end

  # In order to keep using public transport
  # As a customer
  # I want to add money to my card
  it 'so customer can add money, card can be topped up' do
    expect{oystercard.top_up Journey::MIN_FARE}.to change {oystercard.balance }.by (Journey::MIN_FARE)
  end

  # In order to protect my money
  # As a customer
  # I don't want to put too much money on my card
  it 'so customer doesn\'t put too much money on their card, card has a limit' do
    expect{oystercard.top_up(Oystercard::MAX_LIMIT + 1)}.to raise_error("Limit of #{Oystercard::MAX_LIMIT} exceeded, can not top up the card.")
  end

  # In order to pay for my journey
  # As a customer
  # I need my fare deducted from my card
  # it 'so customer can be charged for the journey, card balance can be reduced' do
  #   oystercard.top_up(Journey::MIN_FARE * 2)
  #   expect{oystercard.deduct(Journey::MIN_FARE)}.to change {oystercard.balance }.to (Journey::MIN_FARE)
  # end

  # In order to get through the barriers
  # As a customer
  # I need to touch in and out
  it 'so customer can get through barriers, oystercard can be touched in and out' do
    oystercard.top_up Journey::MIN_FARE
    expect{oystercard.touch_in(entry_station)}.not_to raise_error
    expect{oystercard.touch_out(exit_station)}.not_to raise_error
  end

  context 'so customer can pay for journey' do
    # In order to pay for my journey
    # As a customer
    # I need to have the minimum amount for a single journey
    it 'oystercard has a minimum amount allowed for traveling' do
      expect{oystercard.touch_in(entry_station)}.to raise_error "Insufficient funds. Must top up card."
    end
    # In order to pay for my journey
    # As a customer
    # I need to pay for my journey when it's complete
    it 'oystercard is charged when journey is complete' do
      oystercard.top_up Journey::MIN_FARE
      oystercard.touch_in(entry_station)
      expect{oystercard.touch_out(exit_station)}.to change{oystercard.balance}.to(0)
    end
    # In order to pay for my journey
    # As a customer
    # I need to know where I've travelled from
    it 'oystercard remembers the entry_station' do
      oystercard.top_up Journey::MIN_FARE
      expect{oystercard.touch_in(entry_station)}.to change{oystercard.entry_station}.to(entry_station)
    end
  end

  # In order to know where I have been
  # As a customer
  # I want to see to all my previous trips
  it 'so customer knows where has been, oystercard tracks journeys' do
    oystercard.top_up Journey::MIN_FARE
    journey = Journey.new
    journey.entry_station = entry_station
    journey.exit_station = exit_station
    oystercard.touch_in(entry_station)
    oystercard.touch_out(exit_station)
    # expect(oystercard.journey_history.first).to eq(journey)
    expect(oystercard.journeylog.journeys.first.entry_station.name).to eq(journey.entry_station.name)
    expect(oystercard.journeylog.journeys.first.exit_station.name).to eq(journey.exit_station.name)
  end

  # In order to know how far I have travelled
  # As a customer
  # I want to know what zone a station is in
  # ...Station class that exposes a name and a zone variable
  it 'so customer knows where they have travelled, store station name and zone' do
    oystercard.top_up Journey::MIN_FARE
    oystercard.touch_in(entry_station)
    expect(oystercard.entry_station.zone).to eq(1)
    expect(oystercard.entry_station.name).to eq("Bank")
  end

  context 'so customer is charged correctly' do
    # In order to be charged correctly
    # As a customer
    # I need a penalty charge deducted if I fail to touch in or out
    it 'will be penalized if they forget to touch out' do
      journey = Journey.new
      journey.entry_station = entry_station
      # journey.exit_station = exit_station
      expect(journey.fare).to eq 6
    end
    it 'will be penalized if they forget to touch in' do
      journey = Journey.new
      # journey.entry_station = entry_station
      journey.exit_station = exit_station
      expect(journey.fare).to eq 6
    end

    # In order to be charged the correct amount
    # As a customer
    # I need to have the correct fare calculated
    # We will charge £1  for every journey, plus £1 for every zone boundary crossed.
    # So, a journey within the same zone will cost £1,
    # the journey between zones 1 and 2 will cost £2,
    # and the journey between zones 3 and 5 will cost £3.

    ### build this from the most outer interface
    context 'will be calculated' do
      let(:journey) {Journey.new}
      it 'a fare of 1£ for trips on the same zone' do
        journey.entry_station =  Station.new("Bank", 1)
        journey.exit_station =  Station.new("Bank", 1)
        expect(journey.fare).to eq 1
      end
      it 'a fare of 2£ for trips within 2 zones' do
        journey.entry_station =  Station.new("Bank", 1)
        journey.exit_station =  Station.new("Aldgate East", 2)
        expect(journey.fare).to eq 2

        journey.entry_station =  Station.new("Aldgate East", 2)
        journey.exit_station =  Station.new("Bank", 1)
        expect(journey.fare).to eq 2
      end
      it 'a fare of 3£ for trips within 3 zones' do
        journey.entry_station =  Station.new("Bank", 1)
        journey.exit_station =  Station.new("Stratford", 3)
        expect(journey.fare).to eq 3

        journey.exit_station =  Station.new("Stratford", 3)
        journey.entry_station =  Station.new("Bank", 1)
        expect(journey.fare).to eq 3
      end
    end
  end
end
