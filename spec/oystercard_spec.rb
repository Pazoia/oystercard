require 'oystercard'

describe Oystercard do

  let (:station) { double :station }
  let (:exit_station) { double :exit_station }

before(:each) do
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

  # save entry_station to our new hash (journeys)

    it 'saves the starting station' do
      subject.touch_in(station)
      expect(subject.entry_station).to eq(station)
    end
    
    it 'does not allow touch in, not enough funds' do
      card = Oystercard.new
      expect{ card.touch_in(station) }.to raise_error("Not enough funds on card")
    end
  end

  describe '#touch_out(exit_station)' do

  # save exit_station to our new hash (journeys)

    it 'changes @entry_station status' do
      expect(subject.touch_out(exit_station)).to be(nil)
    end

    it "balance should deduct by #{Oystercard::MIN_BALANCE}" do
      expect { subject.touch_out(exit_station) }.to change { subject.balance }.by(-Oystercard::MIN_BALANCE)
    end

    it "should forget forget entry station" do
      expect { subject.touch_out(exit_station) }.to change {subject.entry_station}.from(station).to(nil)
    end

    it "saves the exit station" do
      expect( subject.touch_out(exit_station) ).to eq(exit_station)
    end
  end

  context 'when in journey' do
 
    it 'returns true' do
      expect(subject.in_journey?).to be true
    end
  end
end
