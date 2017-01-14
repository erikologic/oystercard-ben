require 'oystercard'
# require 'journey'

describe Oystercard do
  let(:oystercard){described_class.new}

  # MIN_FARE = Journey::MIN_FARE
  MIN_FARE = 1

  describe '#balance' do
    it 'checks that the oystercard has a balance' do
      expect(oystercard).to respond_to(:balance)
    end
    it 'has an initial balance' do
      expect(oystercard.balance).to eql 0
    end
  end

  describe '#top_up' do
    it 'allows card to be topped up by a certain amount' do
      expect(oystercard).to respond_to(:top_up).with(1).argument
    end
    it 'the oystercard will accept a value and store it' do
      expect{oystercard.top_up MIN_FARE}.to change {oystercard.balance }.by (MIN_FARE)
    end
  end
  describe 'MAX_LIMIT' do
    it 'will raise an error if top up limit is exceeded' do
      oystercard.top_up(Oystercard::MAX_LIMIT)
      expect{oystercard.top_up(MIN_FARE)}.to raise_error("Limit of #{Oystercard::MAX_LIMIT} exceeded, can not top up the card.")
    end
  end

#deduct method made priavte so tests ommitted for now.

# describe '#deduct' do
#   it 'allows card to have balance deducted' do
#     expect(oystercard).to respond_to(:deduct).with(1).argument
#   end
# end
#
#   describe 'deduct money' do
#   it "will deduct the amount off the card" do
#     expect{oystercard.deduct (MIN_FARE)}.to change {oystercard.balance}.by (-MIN_FARE)
#   end
# end

  describe '#touch_in' do
    let(:entry_station){double :entry_station}

    context 'with min limit on balance' do
      before(:each) do
        oystercard.top_up(MIN_FARE)
      end
      it 'can touch in' do
        expect{oystercard.touch_in(entry_station)}.not_to raise_error
      end
      it 'expect entry station to be recorded' do
        oystercard.touch_in(entry_station)
        expect(oystercard.entry_station).to eq entry_station
      end
    end
    context 'with 0 balance' do
      it 'raises error if not enough balance' do
        expect{oystercard.touch_in(entry_station)}.to raise_error("Insufficient funds. Must top up card.")
      end
    end
  end

  describe '#touch_out' do
    let(:entry_station) {double :station}
    let(:exit_station)  {double :station}
    before(:each) do
      oystercard.top_up(MIN_FARE)
      allow(entry_station).to receive(:zone).and_return(1)
      allow(exit_station).to receive(:zone).and_return(1)
    end

    it 'can touch out' do
      expect{oystercard.touch_out(exit_station)}.not_to raise_error
    end
    it 'to be charged when we touch out of our journey' do
      oystercard.touch_in(entry_station)
      expect{oystercard.touch_out(exit_station)}.to change{oystercard.balance}.by (-MIN_FARE)
    end
  end
end
