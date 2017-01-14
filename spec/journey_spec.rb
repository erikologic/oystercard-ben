require 'journey'

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
    it 'calculates the fare without penalty if touched in and out' do
      complete_journey = Journey.new
      complete_journey.entry_station = :entry_station
      complete_journey.exit_station = :exit_station
      expect(complete_journey.fare).to eq 1
    end
  end
end
