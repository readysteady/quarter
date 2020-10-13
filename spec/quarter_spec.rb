require 'minitest/autorun'
require 'minitest/global_expectations'
require_relative '../lib/quarter'
require_relative '../lib/quarter/yaml'
require 'month'

describe 'Quarter class' do
  let(:year) { 2020 }
  let(:number) { 1 }
  let(:quarter) { Quarter.new(year, number) }

  describe '#initialize' do
    it 'raises an exception given an invalid number' do
      proc { Quarter.new(year, 0) }.must_raise(ArgumentError)
      proc { Quarter.new(year, 5) }.must_raise(ArgumentError)
    end

    it 'returns frozen instances' do
      quarter.frozen?.must_equal(true)
    end
  end

  describe '#year' do
    it 'returns the year' do
      quarter.year.must_equal(year)
    end
  end

  describe '#number' do
    it 'returns the number' do
      quarter.number.must_equal(number)
    end
  end

  describe '#name' do
    it 'returns a string containing the number' do
      quarter.name.must_equal('Q1')
    end
  end

  describe '#to_s' do
    it 'returns a string containing the year and the number' do
      quarter.to_s.must_equal('Q1 2020')
    end
  end

  describe '#iso8601' do
    it 'returns a string containing the year and the number' do
      quarter.iso8601.must_equal('2020-Q1')
    end
  end

  describe '#hash' do
    it 'returns the same value for instances with the same year and number' do
      Quarter.new(year, number).hash.must_equal(Quarter.new(year, number).hash)
    end
  end

  describe '#<=>' do
    it 'returns -1 if the argument comes after' do
      value = Quarter.new(year, 1) <=> Quarter.new(year, 2)
      value.must_equal(-1)
    end

    it 'returns 0 if the argument is the same year and number' do
      value = Quarter.new(year, number) <=> Quarter.new(year, number)
      value.must_equal(0)
    end

    it 'returns -1 if the argument comes before' do
      value = Quarter.new(year, 2) <=> Quarter.new(year, 1)
      value.must_equal(1)
    end

    it 'returns nil if the argument is nil' do
      value = Quarter.new(year, 1) <=> nil
      value.must_be_nil
    end
  end

  describe '#next' do
    it 'returns the next quarter' do
      Quarter.new(year, 1).next.must_equal(Quarter.new(year, 2))
      Quarter.new(year, 2).next.must_equal(Quarter.new(year, 3))
      Quarter.new(year, 3).next.must_equal(Quarter.new(year, 4))
      Quarter.new(year, 4).next.must_equal(Quarter.new(year + 1, 1))
    end
  end

  describe '#prev' do
    it 'returns the previous quarter' do
      Quarter.new(year, 1).prev.must_equal(Quarter.new(year - 1, 4))
      Quarter.new(year, 2).prev.must_equal(Quarter.new(year, 1))
      Quarter.new(year, 3).prev.must_equal(Quarter.new(year, 2))
      Quarter.new(year, 4).prev.must_equal(Quarter.new(year, 3))
    end
  end

  describe '#upto' do
    it 'enumerates quarters up to the given limit' do
      enumerator = Quarter.new(year, 1).upto(Quarter.new(year, 4))

      enumerator.must_be_instance_of(Enumerator)

      enumerator.next.must_equal(Quarter.new(year, 1))
      enumerator.next.must_equal(Quarter.new(year, 2))
      enumerator.next.must_equal(Quarter.new(year, 3))
      enumerator.next.must_equal(Quarter.new(year, 4))

      proc { enumerator.next }.must_raise(StopIteration)
    end
  end

  describe '#downto' do
    it 'enumerates quarters down to the given limit' do
      enumerator = Quarter.new(year, 4).downto(Quarter.new(year, 1))

      enumerator.must_be_instance_of(Enumerator)

      enumerator.next.must_equal(Quarter.new(year, 4))
      enumerator.next.must_equal(Quarter.new(year, 3))
      enumerator.next.must_equal(Quarter.new(year, 2))
      enumerator.next.must_equal(Quarter.new(year, 1))

      proc { enumerator.next }.must_raise(StopIteration)
    end
  end

  describe '#+' do
    it 'returns the quarter the given number of quarters after' do
      (Quarter.new(year, 1) + 1).must_equal(Quarter.new(year, 2))
      (Quarter.new(year, 2) + 1).must_equal(Quarter.new(year, 3))
      (Quarter.new(year, 3) + 1).must_equal(Quarter.new(year, 4))
      (Quarter.new(year, 4) + 1).must_equal(Quarter.new(year + 1, 1))

      (Quarter.new(year, 1) + 2).must_equal(Quarter.new(year, 3))
      (Quarter.new(year, 2) + 2).must_equal(Quarter.new(year, 4))
      (Quarter.new(year, 3) + 2).must_equal(Quarter.new(year + 1, 1))
      (Quarter.new(year, 4) + 2).must_equal(Quarter.new(year + 1, 2))
    end
  end

  describe '#-' do
    it 'returns the quarter the given number of quarters before' do
      (Quarter.new(year, 1) - 1).must_equal(Quarter.new(year - 1, 4))
      (Quarter.new(year, 2) - 1).must_equal(Quarter.new(year, 1))
      (Quarter.new(year, 3) - 1).must_equal(Quarter.new(year, 2))
      (Quarter.new(year, 4) - 1).must_equal(Quarter.new(year, 3))

      (Quarter.new(year, 1) - 2).must_equal(Quarter.new(year - 1, 3))
      (Quarter.new(year, 2) - 2).must_equal(Quarter.new(year - 1, 4))
      (Quarter.new(year, 3) - 2).must_equal(Quarter.new(year, 1))
      (Quarter.new(year, 4) - 2).must_equal(Quarter.new(year, 2))
    end

    it 'returns the number of quarters between the two quarters' do
      (Quarter.new(year, 1) - Quarter.new(year, 1)).must_equal(0)
      (Quarter.new(year, 4) - Quarter.new(year, 1)).must_equal(3)
      (Quarter.new(year + 3, 1) - Quarter.new(year, 1)).must_equal(12)
    end
  end

  describe '#include?' do
    it 'returns true when the quarter includes the given date' do
      quarter.include?(Date.new(year, 1, 1)).must_equal(true)
    end

    it 'returns false otherwise' do
      quarter.include?(Date.new(year, 4, 1)).must_equal(false)
    end
  end

  describe '#===' do
    it 'returns true when the quarter includes the given date' do
      (quarter === Date.new(year, 1, 1)).must_equal(true)
    end

    it 'returns false otherwise' do
      (quarter === Date.new(year, 4, 1)).must_equal(false)
    end
  end

  describe '#start_date' do
    it 'returns the first date in the quarter' do
      Quarter.new(year, 1).start_date.must_equal(Date.new(year, 1, 1))
      Quarter.new(year, 2).start_date.must_equal(Date.new(year, 4, 1))
      Quarter.new(year, 3).start_date.must_equal(Date.new(year, 7, 1))
      Quarter.new(year, 4).start_date.must_equal(Date.new(year, 10, 1))
    end
  end

  describe '#end_date' do
    it 'returns the last date in the quarter' do
      Quarter.new(year, 1).end_date.must_equal(Date.new(year, 3, 31))
      Quarter.new(year, 2).end_date.must_equal(Date.new(year, 6, 30))
      Quarter.new(year, 3).end_date.must_equal(Date.new(year, 9, 30))
      Quarter.new(year, 4).end_date.must_equal(Date.new(year, 12, 31))
    end
  end

  describe '#dates' do
    it 'returns the range of dates in the quarter' do
      range = Quarter.new(year, 2).dates
      range.must_be_instance_of(Range)
      range.count.must_equal(91)
      range.all? { |date| Date === date }.must_equal(true)
      range.first.must_equal(Date.new(year, 4, 1))
      range.last.must_equal(Date.new(year, 6, 30))
    end
  end

  describe '#length' do
    it 'returns the integer number of days in the quarter' do
      Quarter.new(2000, 1).length.must_equal(91)
      Quarter.new(2001, 1).length.must_equal(90)
      Quarter.new(year, 2).length.must_equal(91)
      Quarter.new(year, 3).length.must_equal(92)
      Quarter.new(year, 4).length.must_equal(92)
    end
  end

  describe '#months' do
    it 'returns the range of months in the quarter' do
      range = quarter.months
      range.must_be_instance_of(Range)
      range.count.must_equal(3)
      range.all? { |month| Month === month }.must_equal(true)
      range.first.must_equal(Month.new(year, 1))
      range.last.must_equal(Month.new(year, 3))
    end
  end
end

describe 'Quarter method' do
  let(:year) { 2020 }
  let(:number) { 1 }
  let(:quarter) { Quarter.new(year, number) }

  it 'returns the quarter for the given date' do
    Quarter(Date.new(year, 1, 1)).must_equal(quarter)
  end

  it 'returns the quarter for the given time' do
    Quarter(Time.utc(year, 1, 1)).must_equal(quarter)
  end

  it 'returns the quarter for the given datetime' do
    Quarter(DateTime.parse('2001-02-03T04:05:06+07:00')).must_equal(Quarter.new(2001, 1))
  end

  it 'returns the given quarter' do
    Quarter(quarter).object_id.must_equal(quarter.object_id)
  end

  it 'returns the quarter number for the given month number' do
    Quarter(1).must_equal(1)
    Quarter(4).must_equal(2)
    Quarter(7).must_equal(3)
    Quarter(10).must_equal(4)
  end
end

describe 'Quarter.parse' do
  it 'returns the quarter for the given string representation' do
    Quarter.parse('2020-Q1').must_equal(Quarter.new(2020, 1))
    Quarter.parse('Q1 2020').must_equal(Quarter.new(2020, 1))
  end

  it 'raises an exception given an invalid string representation' do
    proc { Quarter.parse('Q1') }.must_raise(ArgumentError)
    proc { Quarter.parse('2020') }.must_raise(ArgumentError)
    proc { Quarter.parse('quarter') }.must_raise(ArgumentError)
  end
end

describe 'Quarter.today' do
  let(:current_quarter) { Quarter(Date.today) }

  it 'returns the current quarter' do
    Quarter.today.must_equal(current_quarter)
  end
end

describe 'Quarter.now' do
  let(:current_quarter) { Quarter(Time.now) }

  it 'returns the current quarter' do
    Quarter.now.must_equal(current_quarter)
  end
end

describe 'YAML' do
  let(:quarter) { Quarter.new(2020, 1) }

  it 'dumps quarter objects' do
    YAML.dump([quarter]).must_equal("---\n- Q1 2020\n")
  end

  it 'loads quarter objects' do
    YAML.load("---\n- Q1 2020\n").must_equal([quarter])

    YAML.load("---\n- 2020-Q1\n").must_equal([quarter])
    YAML.load("---\n- 2020/Q1\n").must_equal([quarter])

    YAML.load("---\n- Q12020\n").must_equal([quarter])
    YAML.load("---\n- 2020Q1\n").must_equal([quarter])
  end
end

describe 'Quarter::Methods' do
  include Quarter::Methods

  describe 'Q1' do
    it 'returns the 1st quarter' do
      Q1(2020).must_equal(Quarter.new(2020, 1))
    end
  end

  describe 'Q2' do
    it 'returns the 2nd quarter' do
      Q2(2020).must_equal(Quarter.new(2020, 2))
    end
  end

  describe 'Q3' do
    it 'returns the 3rd quarter' do
      Q3(2020).must_equal(Quarter.new(2020, 3))
    end
  end

  describe 'Q4' do
    it 'returns the 4th quarter' do
      Q4(2020).must_equal(Quarter.new(2020, 4))
    end
  end
end

describe 'Quarter::Constants' do
  describe 'Q1' do
    it 'returns the 1st quarter' do
      Q1 = Quarter::Constants::Q1

      (2020-Q1).must_equal(Quarter.new(2020, 1))
      (2020/Q1).must_equal(Quarter.new(2020, 1))
    end
  end

  describe 'Q2' do
    it 'returns the 2nd quarter' do
      Q2 = Quarter::Constants::Q2

      (2020-Q2).must_equal(Quarter.new(2020, 2))
      (2020/Q2).must_equal(Quarter.new(2020, 2))
    end
  end

  describe 'Q3' do
    it 'returns the 3rd quarter' do
      Q3 = Quarter::Constants::Q3

      (2020-Q3).must_equal(Quarter.new(2020, 3))
      (2020/Q3).must_equal(Quarter.new(2020, 3))
    end
  end

  describe 'Q4' do
    it 'returns the 4th quarter' do
      Q4 = Quarter::Constants::Q4

      (2020-Q4).must_equal(Quarter.new(2020, 4))
      (2020/Q4).must_equal(Quarter.new(2020, 4))
    end
  end
end
