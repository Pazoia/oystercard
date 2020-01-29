require 'oystercard'

describe Oystercard do
  it { is_expected.to respond_to(:balance)}

  it { is_expected.to respond_to(:touch_in) }

  it 'returns balance of 0' do
    expect(subject.balance).to eq 0
  end

  describe '#top_up' do
    it 'tops up card balance' do
      expect{subject.top_up(10)}.to change{subject.balance}.by(10)
    end

    it 'does not allow balance to exceed 90' do
      max_balance = Oystercard::MAX_BALANCE
      subject.top_up(max_balance)
      expect{ subject.top_up(1) }.to raise_error("Amount entered exceeds top limit of £#{max_balance}")
    end
  end

  describe '#touch_in' do
    it 'returns "in use" ' do
      subject.top_up(2)
      expect(subject.touch_in).to be true
    end

    it 'does not allow touch in, not enough funds' do
      expect{ subject.touch_in }.to raise_error("Not enough funds on card")
      subject.top_up(10)
      expect( subject.touch_in).to be true
    end

    it 'raises an error if minimum fare not met' do
      min_balance = Oystercard::MIN_BALANCE
      expect{ subject.touch_in }.to raise_error("Minimum fare of £#{min_balance} not met")
    end
  end

  describe '#touch_out' do
    it 'returns "not in use"' do
      expect(subject.touch_out).to be false
    end

    it 'charges for journey' do
      min_balance = Oystercard::MIN_BALANCE
      expect{subject.touch_out}.to change{subject.balance}.by(-min_balance)
    end
  end

  context 'when not in journey' do
    it 'returns false' do
      expect(subject.in_journey?).to be false
    end
  end

  context 'when in journey' do
    before do
      subject.top_up(10)
    end
    it 'returns true' do
      subject.top_up(2)
      subject.touch_in
      expect(subject.in_journey?).to be true
    end
  end

end
