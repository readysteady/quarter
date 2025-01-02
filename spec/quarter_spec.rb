require_relative '../lib/quarter'
require_relative '../lib/quarter/yaml'
require 'month'

RSpec.describe Quarter do
  let(:year) { 2020 }
  let(:number) { 1 }
  let(:quarter) { Quarter.new(year, number) }

  describe '#initialize' do
    it 'returns frozen instances' do
      expect(quarter.frozen?).to eq(true)
    end

    context 'with an invalid number' do
      it 'raises an exception' do
        expect { Quarter.new(year, 0) }.to raise_error(ArgumentError)
        expect { Quarter.new(year, 5) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#year' do
    it 'returns the year' do
      expect(quarter.year).to eq(year)
    end
  end

  describe '#number' do
    it 'returns the number' do
      expect(quarter.number).to eq(number)
    end
  end

  describe '#name' do
    it 'returns a string containing the number' do
      expect(quarter.name).to eq('Q1')
    end
  end

  describe '#to_s' do
    it 'returns a string containing the year and the number' do
      expect(quarter.to_s).to eq('Q1 2020')
    end
  end

  describe '#iso8601' do
    it 'returns a string containing the year and the number' do
      expect(quarter.iso8601).to eq('2020-Q1')
    end
  end

  describe '#inspect' do
    it 'returns a string containing the year and the number' do
      expect(quarter.inspect).to eq('<Quarter: Q1 2020>')
    end
  end

  describe '#hash' do
    it 'returns the same value for instances with the same year and number' do
      expect(Quarter.new(year, number).hash).to eq(Quarter.new(year, number).hash)
    end
  end

  describe '#<=>' do
    context 'when the argument comes after' do
      it 'returns -1' do
        value = Quarter.new(year, 1) <=> Quarter.new(year, 2)

        expect(value).to eq(-1)
      end
    end

    context 'when the argument is the same year and number' do
      it 'returns 0' do
        value = Quarter.new(year, number) <=> Quarter.new(year, number)

        expect(value).to eq(0)
      end
    end

    context 'when the argument comes before' do
      it 'returns -1' do
        value = Quarter.new(year, 2) <=> Quarter.new(year, 1)

        expect(value).to eq(1)
      end
    end

    context 'when the argument is nil' do
      it 'returns nil' do
        value = Quarter.new(year, 1) <=> nil

        expect(value).to be_nil
      end
    end
  end

  describe '#next' do
    it 'returns the next quarter' do
      expect(Quarter.new(year, 1).next).to eq(Quarter.new(year, 2))
      expect(Quarter.new(year, 2).next).to eq(Quarter.new(year, 3))
      expect(Quarter.new(year, 3).next).to eq(Quarter.new(year, 4))
      expect(Quarter.new(year, 4).next).to eq(Quarter.new(year + 1, 1))
    end
  end

  describe '#prev' do
    it 'returns the previous quarter' do
      expect(Quarter.new(year, 1).prev).to eq(Quarter.new(year - 1, 4))
      expect(Quarter.new(year, 2).prev).to eq(Quarter.new(year, 1))
      expect(Quarter.new(year, 3).prev).to eq(Quarter.new(year, 2))
      expect(Quarter.new(year, 4).prev).to eq(Quarter.new(year, 3))
    end
  end

  describe '#upto' do
    it 'enumerates quarters up to the given limit' do
      enumerator = Quarter.new(year, 1).upto(Quarter.new(year, 4))

      expect(enumerator).to be_an(Enumerator)

      expect(enumerator.next).to eq(Quarter.new(year, 1))
      expect(enumerator.next).to eq(Quarter.new(year, 2))
      expect(enumerator.next).to eq(Quarter.new(year, 3))
      expect(enumerator.next).to eq(Quarter.new(year, 4))

      expect { enumerator.next }.to raise_error(StopIteration)
    end
  end

  describe '#downto' do
    it 'enumerates quarters down to the given limit' do
      enumerator = Quarter.new(year, 4).downto(Quarter.new(year, 1))

      expect(enumerator).to be_an(Enumerator)

      expect(enumerator.next).to eq(Quarter.new(year, 4))
      expect(enumerator.next).to eq(Quarter.new(year, 3))
      expect(enumerator.next).to eq(Quarter.new(year, 2))
      expect(enumerator.next).to eq(Quarter.new(year, 1))

      expect { enumerator.next }.to raise_error(StopIteration)
    end
  end

  describe '#+' do
    it 'returns the quarter the given number of quarters after' do
      expect(Quarter.new(year, 1) + 1).to eq(Quarter.new(year, 2))
      expect(Quarter.new(year, 2) + 1).to eq(Quarter.new(year, 3))
      expect(Quarter.new(year, 3) + 1).to eq(Quarter.new(year, 4))
      expect(Quarter.new(year, 4) + 1).to eq(Quarter.new(year + 1, 1))

      expect(Quarter.new(year, 1) + 2).to eq(Quarter.new(year, 3))
      expect(Quarter.new(year, 2) + 2).to eq(Quarter.new(year, 4))
      expect(Quarter.new(year, 3) + 2).to eq(Quarter.new(year + 1, 1))
      expect(Quarter.new(year, 4) + 2).to eq(Quarter.new(year + 1, 2))
    end
  end

  describe '#-' do
    it 'returns the quarter the given number of quarters before' do
      expect(Quarter.new(year, 1) - 1).to eq(Quarter.new(year - 1, 4))
      expect(Quarter.new(year, 2) - 1).to eq(Quarter.new(year, 1))
      expect(Quarter.new(year, 3) - 1).to eq(Quarter.new(year, 2))
      expect(Quarter.new(year, 4) - 1).to eq(Quarter.new(year, 3))

      expect(Quarter.new(year, 1) - 2).to eq(Quarter.new(year - 1, 3))
      expect(Quarter.new(year, 2) - 2).to eq(Quarter.new(year - 1, 4))
      expect(Quarter.new(year, 3) - 2).to eq(Quarter.new(year, 1))
      expect(Quarter.new(year, 4) - 2).to eq(Quarter.new(year, 2))
    end

    it 'returns the number of quarters between the two quarters' do
      expect(Quarter.new(year, 1) - Quarter.new(year, 1)).to eq(0)
      expect(Quarter.new(year, 4) - Quarter.new(year, 1)).to eq(3)
      expect(Quarter.new(year + 3, 1) - Quarter.new(year, 1)).to eq(12)
    end
  end

  describe '#include?' do
    it 'returns true when the quarter includes the given date' do
      expect(quarter.include?(Date.new(year, 1, 1))).to eq(true)
    end

    it 'returns false otherwise' do
      expect(quarter.include?(Date.new(year, 4, 1))).to eq(false)
    end
  end

  describe '#===' do
    it 'returns true when the quarter includes the given date' do
      expect(quarter === Date.new(year, 1, 1)).to eq(true)
    end

    it 'returns false otherwise' do
      expect(quarter === Date.new(year, 4, 1)).to eq(false)
    end
  end

  describe '#start_date' do
    it 'returns the first date in the quarter' do
      expect(Quarter.new(year, 1).start_date).to eq(Date.new(year, 1, 1))
      expect(Quarter.new(year, 2).start_date).to eq(Date.new(year, 4, 1))
      expect(Quarter.new(year, 3).start_date).to eq(Date.new(year, 7, 1))
      expect(Quarter.new(year, 4).start_date).to eq(Date.new(year, 10, 1))
    end
  end

  describe '#end_date' do
    it 'returns the last date in the quarter' do
      expect(Quarter.new(year, 1).end_date).to eq(Date.new(year, 3, 31))
      expect(Quarter.new(year, 2).end_date).to eq(Date.new(year, 6, 30))
      expect(Quarter.new(year, 3).end_date).to eq(Date.new(year, 9, 30))
      expect(Quarter.new(year, 4).end_date).to eq(Date.new(year, 12, 31))
    end
  end

  describe '#dates' do
    it 'returns the range of dates in the quarter' do
      range = Quarter.new(year, 2).dates

      expect(range).to be_a(Range)
      expect(range.count).to eq(91)
      expect(range.all? { |date| Date === date }).to eq(true)
      expect(range.first).to eq(Date.new(year, 4, 1))
      expect(range.last).to eq(Date.new(year, 6, 30))
    end
  end

  describe '#length' do
    it 'returns the integer number of days in the quarter' do
      expect(Quarter.new(2000, 1).length).to eq(91)
      expect(Quarter.new(2001, 1).length).to eq(90)
      expect(Quarter.new(year, 2).length).to eq(91)
      expect(Quarter.new(year, 3).length).to eq(92)
      expect(Quarter.new(year, 4).length).to eq(92)
    end
  end

  describe '#months' do
    it 'returns the range of months in the quarter' do
      range = quarter.months

      expect(range).to be_a(Range)
      expect(range.count).to eq(3)
      expect(range.all? { |month| Month === month }).to eq(true)
      expect(range.first).to eq(Month.new(year, 1))
      expect(range.last).to eq(Month.new(year, 3))
    end
  end
end

RSpec.describe 'Quarter(object)' do
  let(:year) { 2020 }
  let(:number) { 1 }
  let(:quarter) { Quarter.new(year, number) }

  it 'returns the quarter for the given date' do
    expect(Quarter(Date.new(year, 1, 1))).to eq(quarter)
  end

  it 'returns the quarter for the given time' do
    expect(Quarter(Time.utc(year, 1, 1))).to eq(quarter)
  end

  it 'returns the quarter for the given datetime' do
    expect(Quarter(DateTime.parse('2001-02-03T04:05:06+07:00'))).to eq(Quarter.new(2001, 1))
  end

  it 'returns the given quarter' do
    expect(Quarter(quarter).object_id).to eq(quarter.object_id)
  end

  it 'returns the quarter number for the given month number' do
    expect(Quarter(1)).to eq(1)
    expect(Quarter(4)).to eq(2)
    expect(Quarter(7)).to eq(3)
    expect(Quarter(10)).to eq(4)
  end
end

RSpec.describe 'Quarter.parse' do
  it 'returns the quarter for the given string representation' do
    expect(Quarter.parse('2020-Q1')).to eq(Quarter.new(2020, 1))
    expect(Quarter.parse('Q1 2020')).to eq(Quarter.new(2020, 1))
  end

  it 'raises an exception given an invalid string representation' do
    expect { Quarter.parse('Q1') }.to raise_error(ArgumentError)
    expect { Quarter.parse('2020') }.to raise_error(ArgumentError)
    expect { Quarter.parse('quarter') }.to raise_error(ArgumentError)
  end
end

RSpec.describe 'Quarter.today' do
  let(:current_quarter) { Quarter(Date.today) }

  it 'returns the current quarter' do
    expect(Quarter.today).to eq(current_quarter)
  end
end

RSpec.describe 'Quarter.now' do
  let(:current_quarter) { Quarter(Time.now) }

  it 'returns the current quarter' do
    expect(Quarter.now).to eq(current_quarter)
  end
end

RSpec.describe 'YAML' do
  let(:quarter) { Quarter.new(2020, 1) }

  describe '.dump' do
    it 'dumps quarter objects' do
      expect(YAML.dump([quarter])).to eq("---\n- Q1 2020\n")
    end
  end

  describe '.load' do
    it 'loads quarter objects' do
      expect(YAML.load("---\n- Q1 2020\n")).to eq([quarter])

      expect(YAML.load("---\n- 2020-Q1\n")).to eq([quarter])
      expect(YAML.load("---\n- 2020/Q1\n")).to eq([quarter])

      expect(YAML.load("---\n- Q12020\n")).to eq([quarter])
      expect(YAML.load("---\n- 2020Q1\n")).to eq([quarter])
    end
  end
end

RSpec.describe Quarter::Methods do
  include Quarter::Methods

  describe 'Q1' do
    it 'returns the 1st quarter' do
      expect(Q1(2020)).to eq(Quarter.new(2020, 1))
    end
  end

  describe 'Q2' do
    it 'returns the 2nd quarter' do
      expect(Q2(2020)).to eq(Quarter.new(2020, 2))
    end
  end

  describe 'Q3' do
    it 'returns the 3rd quarter' do
      expect(Q3(2020)).to eq(Quarter.new(2020, 3))
    end
  end

  describe 'Q4' do
    it 'returns the 4th quarter' do
      expect(Q4(2020)).to eq(Quarter.new(2020, 4))
    end
  end
end

RSpec.describe Quarter::Constants do
  describe 'Q1' do
    it 'returns the 1st quarter' do
      Q1 = Quarter::Constants::Q1

      expect(2020-Q1).to eq(Quarter.new(2020, 1))
      expect(2020/Q1).to eq(Quarter.new(2020, 1))
    end
  end

  describe 'Q2' do
    it 'returns the 2nd quarter' do
      Q2 = Quarter::Constants::Q2

      expect(2020-Q2).to eq(Quarter.new(2020, 2))
      expect(2020/Q2).to eq(Quarter.new(2020, 2))
    end
  end

  describe 'Q3' do
    it 'returns the 3rd quarter' do
      Q3 = Quarter::Constants::Q3

      expect(2020-Q3).to eq(Quarter.new(2020, 3))
      expect(2020/Q3).to eq(Quarter.new(2020, 3))
    end
  end

  describe 'Q4' do
    it 'returns the 4th quarter' do
      Q4 = Quarter::Constants::Q4

      expect(2020-Q4).to eq(Quarter.new(2020, 4))
      expect(2020/Q4).to eq(Quarter.new(2020, 4))
    end
  end
end
