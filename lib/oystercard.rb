class Oystercard
  attr_reader :balance, :entry_station
  MAX_BALANCE = 90
  MIN_BALANCE = 1

  def initialize
    @balance = 0
    @entry_station = nil
  end

  def top_up(amount)
    fail "Amount entered exceeds top limit of £#{MAX_BALANCE}" if maximum_limit?(amount)
    @balance += amount
  end

  def touch_in(station)
    fail "Not enough funds on card" if @balance < MIN_BALANCE
    @entry_station = station
  end

  def touch_out(exit_station)
    deduct(MIN_BALANCE)
    @entry_station = nil
  end

  def in_journey?
    @entry_station != nil
  end

  private
  def maximum_limit?(amount)
    balance + amount > MAX_BALANCE
  end

  def minimum_balance?
    @balance < MIN_BALANCE
  end

  def deduct(amount)
    @balance -= amount
  end

end
