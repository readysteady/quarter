# frozen_string_literal: true
require 'date'

class Quarter
  def initialize(year, number)
    unless number.between?(1, 4)
      raise ArgumentError, 'invalid quarter number'
    end

    @year = year

    @number = number

    freeze
  end

  attr_reader :year

  attr_reader :number

  def name
    "Q#{@number}"
  end

  def to_s
    "Q#{@number} #{@year}"
  end

  def iso8601
    "#{@year}-Q#{@number}"
  end

  def inspect
    "<Quarter: #{to_s}>"
  end

  def hash
    iso8601.hash
  end

  def eql?(other)
    other.class == self.class && other.hash == self.hash
  end

  def <=>(other)
    return unless other.class == self.class

    if @year == other.year
      @number <=> other.number
    else
      @year <=> other.year
    end
  end

  include Comparable

  def next
    self + 1
  end

  alias_method :succ, :next

  alias_method :next_quarter, :next

  def prev
    self - 1
  end

  alias_method :prev_quarter, :prev

  def step(limit, step = 1)
    raise ArgumentError if step.zero?

    return enum_for(:step, limit, step) unless block_given?

    quarter = self

    operator = step > 0 ? :> : :<

    until quarter.public_send(operator, limit)
      yield quarter

      quarter += step
    end
  end

  def upto(max, &block)
    step(max, 1, &block)
  end

  def downto(min, &block)
    step(min, -1, &block)
  end

  def +(other)
    years, remainder = (@number - 1 + other.to_i).divmod(4)

    self.class.new(@year + years, 1 + remainder)
  end

  def -(other)
    if other.class == self.class
      (@year * 4 + @number) - (other.year * 4 + other.number)
    else
      self + (-other)
    end
  end

  def include?(date)
    @year == date.year && @number == Quarter(date.month)
  end

  alias_method :===, :include?

  def start_date
    Date.new(@year, @number * 3 - 2, 1)
  end

  def end_date
    Date.new(@year, @number * 3, -1)
  end

  def dates
    start_date .. end_date
  end

  def length
    case @number
    when 1 then Date.gregorian_leap?(@year) ? 91 : 90
    when 2 then 91
    when 3, 4 then 92
    end
  end

  def months
    Month.new(@year, @number) .. Month.new(@year, @number + 2)
  end
end

def Quarter(object)
  case object
  when Quarter
    object
  when Integer
    (object / 3.0).ceil
  else
    Quarter.new(object.year, Quarter(object.month))
  end
end

class Quarter
  REGEXP = /\AQ(1|2|3|4) (\d{4})\z/i

  private_constant :REGEXP

  ISO8601_REGEXP = /\A(\d{4})\-Q(1|2|3|4)\z/i

  private_constant :ISO8601_REGEXP

  def self.parse(string)
    case string
    when REGEXP
      Quarter.new($2.to_i, $1.to_i)
    when ISO8601_REGEXP
      Quarter.new($1.to_i, $2.to_i)
    else
      raise ArgumentError, 'invalid quarter string'
    end
  end
end

def Quarter.today
  Quarter(Date.today)
end

def Quarter.now
  Quarter(Time.now)
end

module Quarter::Methods
  def Q1(year)
    Quarter.new(year, 1)
  end

  def Q2(year)
    Quarter.new(year, 2)
  end

  def Q3(year)
    Quarter.new(year, 3)
  end

  def Q4(year)
    Quarter.new(year, 4)
  end
end

class Quarter::Constant
  def initialize(number)
    @number = number
  end

  def -(other)
    raise ArgumentError unless other.kind_of?(Integer)

    Quarter.new(other, @number)
  end

  def /(other)
    raise ArgumentError unless other.kind_of?(Integer)

    Quarter.new(other, @number)
  end

  def coerce(other)
    unless other.kind_of?(Integer)
      raise TypeError, "#{self.class} can't be coerced with #{other.class}"
    end

    return self, other
  end
end

module Quarter::Constants
  Q1 = Quarter::Constant.new(1)
  Q2 = Quarter::Constant.new(2)
  Q3 = Quarter::Constant.new(3)
  Q4 = Quarter::Constant.new(4)
end
