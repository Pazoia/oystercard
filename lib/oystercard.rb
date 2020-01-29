class Oystercard
  attr_reader :balance
  MAX_BALANCE = 90
  MIN_BALANCE = 1
  
  def initialize
    @balance = 0
    @in_use = false
  end

  def top_up(amount)
    fail "Amount entered exceeds top limit of £#{MAX_BALANCE}" if maximum_limit?(amount)
    @balance += amount
  end
  
  def touch_in
    fail "Not enough funds on card" if @balance < MIN_BALANCE
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
<<<<<<< HEAD
=======

  def minimum_balance?
    @balance < MIN_BALANCE
  end

  def deduct(amount)
    @balance -= amount
  end
>>>>>>> e53e916b8fe546e1aa9cff72eea6d1267c641f66
end
