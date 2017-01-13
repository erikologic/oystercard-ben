require 'journeylog'

describe JourneyLog do
  let(:station){double :station}
  let(:journey){double :journey}
  let(:journey_class){double :journey_class, new: journey}
  let(:journeylog){described_class.new(journey_class: journey_class)}


  it 'can be initialized with a journey_class parameter' do
    expect{described_class.new(journey_class: journey_class)}.not_to raise_error
  end

  describe '#current_journey' do #private
    it 'should return an incomplete journey or create a new journey' do
      expect(journeylog.current_journey).to eq journey
    end
  end

  describe '#start(station)' do
    it 'should start a new journey with an entry station' do
      expect(journey).to receive(:entry_station=).with(station)
      journeylog.start(station)
    end
    it 'records a journey' do
      allow(journey).to receive(:entry_station=)
      # allow(journey_class).to receive(:new).and_return journey
      journeylog.start(station)
      expect(journeylog.journeys).to include journey
    end
  end

  describe '#finish(station)' do
    it 'should add an exit station to the current_journey' do
      expect(journey).to receive(:exit_station=).with(station)
      # expect(journey_class).to receive(:new).with(exit_station: station)
      journeylog.finish(station)
    end
  end

  describe '#journeys' do
    it 'should return a list of all previous journeys without exposing the internal array to external modification' do
      allow(journey).to receive(:entry_station=)
      allow(journey).to receive(:exit_station=)
      journeylog.start(station)
      journeylog.finish(station)
      expect(journeylog.journeys).to eq [journey]
    end
  end
end
