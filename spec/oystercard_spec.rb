require 'oystercard'

describe Oystercard do

  let (:entry_station) { double :entry_station }
  let (:exit_station) { double :exit_station }
  let (:oyster) { Oystercard.new }

  it 'equals an empty hash' do
    expect(oyster.journeys).to eq([])
  end

  it 'returns balance of 0' do
    expect(oyster.balance).to eq 0
  end

  describe '#top_up' do
    it 'tops up card balance' do
      expect{oyster.top_up(Oystercard::MIN_BALANCE)}.to change{oyster.balance}.by(Oystercard::MIN_BALANCE)
    end

    it 'does not allow balance to exceed 90' do
      oyster.top_up(Oystercard::MAX_BALANCE)
      expect{ oyster.top_up(Oystercard::MIN_BALANCE) }.to raise_error("Amount entered exceeds top limit of £#{Oystercard::MAX_BALANCE}")
    end
  end

  describe '#touch_in' do
    
    it 'saves the starting station' do
      oyster.top_up(Oystercard::MIN_BALANCE)
      oyster.touch_in(entry_station)
      expect(oyster.entry_station).to eq(entry_station)
    end
    
    it 'does not allow touch in, not enough funds' do
      expect{ oyster.touch_in(entry_station) }.to raise_error("Not enough funds on card")
    end
  end

  describe '#touch_out(exit_station)' do

    before(:each) do
      oyster.top_up(Oystercard::MIN_BALANCE)
      oyster.touch_in(entry_station)
    end


    it 'changes @entry_station status' do
      expect(oyster.touch_out(exit_station)).to be(nil)
    end

    it "balance should deduct by #{Oystercard::MIN_BALANCE}" do
      expect { oyster.touch_out(exit_station) }.to change { oyster.balance }.by(-Oystercard::MIN_BALANCE)
    end

    it "should forget forget entry station" do
      expect { oyster.touch_out(exit_station) }.to change {oyster.entry_station}.from(entry_station).to(nil)
    end

    it "saves a whole journey into journeys hash" do
      expect { oyster.touch_out(exit_station) }.to change { oyster.journeys }.from([]).to([{entry: entry_station, exit: exit_station}])
    end
  end

  context 'when in journey' do
 
    it 'returns true' do
      oyster.top_up(Oystercard::MIN_BALANCE)
      oyster.touch_in(entry_station)
      expect(oyster.in_journey?).to be true
    end
  end
end
