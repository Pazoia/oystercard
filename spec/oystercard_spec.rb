require 'oystercard'

describe Oystercard do

before(:each) do
  station = double('Aldgate')
  subject.top_up(20)
  subject.touch_in(station)
end

  it 'returns balance of 0' do
    card = Oystercard.new
    expect(card.balance).to eq 0
  end

  describe '#top_up' do
    it 'tops up card balance' do
      expect{subject.top_up(10)}.to change{subject.balance}.by(10)
    end

    it 'does not allow balance to exceed 90' do
      max_balance = Oystercard::MAX_BALANCE
      card = Oystercard.new
      card.top_up(max_balance)
      expect{ card.top_up(1) }.to raise_error("Amount entered exceeds top limit of £#{max_balance}")
    end
  end

  describe '#touch_in' do
    it 'returns "in use" ' do
      expect(subject.in_use).to be true
    end

    it 'saves the starting station' do
      station = double("Aldgate")
      subject.top_up(20)
      subject.touch_in(station)
      expect(subject.journey_start).to eq(station)
    end
    
    it 'does not allow touch in, not enough funds' do
      card = Oystercard.new
      station = double('Aldgate')
      expect{ card.touch_in(station) }.to raise_error("Not enough funds on card")
    end
  end

  describe '#touch_out' do
    it 'returns "not in use"' do
      expect(subject.touch_out).to be false
    end

    it "balance should deduct by #{Oystercard::MIN_BALANCE}" do
      expect { subject.touch_out }.to change { subject.balance }.by(-Oystercard::MIN_BALANCE)
    end
  end

  context 'when in journey' do
 
    it 'returns true' do
      expect(subject.in_journey?).to be true
    end

  end

end
