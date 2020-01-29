class Oystercard
  attr_reader :balance, :journey_start, :in_use
  MAX_BALANCE = 90
  MIN_BALANCE = 1

  def initialize
    @balance = 0
    @in_use = false
    @journey_start = nil
  end

  def top_up(amount)
    fail "Amount entered exceeds top limit of £#{MAX_BALANCE}" if maximum_limit?(amount)
    @balance += amount
  end

  def touch_in(station)
    fail "Not enough funds on card" if @balance < MIN_BALANCE
    @journey_start = station
    @in_use = true
  end

  def touch_out
    deduct(MIN_BALANCE)
    @in_use = false
  end

  def in_journey?
    @in_use == true
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
