require 'journey'
require 'station'

describe Journey do
  let (:journey) { Journey.new }

  it 'can save an entry station' do
    expect{journey.entry_station="Bank"}.not_to raise_error
  end
  it 'can save an exit station' do
    expect{journey.exit_station="Bank"}.not_to raise_error
  end

  describe '#fare' do
    it 'calculates fare with penalty if forgotten to touch in/out' do
      expect(journey.fare).to eq 6
    end
    context 'will be calculated' do
      it 'a fare of 1£ for trips on the same zone' do
        journey = Journey.new
        journey.entry_station =  Station.new("Bank", 1)
        journey.exit_station =  Station.new("Bank", 1)
        expect(journey.fare).to eq 1
      end
      it 'a fare of 2£ for trips within 2 zones' do
        journey = Journey.new
        journey.entry_station =  Station.new("Bank", 1)
        journey.exit_station =  Station.new("Aldgate East", 2)
        expect(journey.fare).to eq 2

        journey = Journey.new
        journey.entry_station =  Station.new("Aldgate East", 2)
        journey.exit_station =  Station.new("Bank", 1)
        expect(journey.fare).to eq 2
      end
      it 'a fare of 3£ for trips within 3 zones' do
        journey = Journey.new
        journey.entry_station =  Station.new("Bank", 1)
        journey.exit_station =  Station.new("Stratford", 3)
        expect(journey.fare).to eq 3

        journey = Journey.new
        journey.exit_station =  Station.new("Stratford", 3)
        journey.entry_station =  Station.new("Bank", 1)
        expect(journey.fare).to eq 3
      end
    end
  end
end
