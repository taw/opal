require 'corelib/enumerable'

class Range
  include Enumerable

  `def.$$is_range = true;`

  attr_reader :begin, :end

  def initialize(first, last, exclude = false)
    raise NameError, "initialize' called twice" if @begin
    raise ArgumentError unless first <=> last

    @begin   = first
    @end     = last
    @exclude = exclude
  end

  def ==(other)
    %x{
      if (!other.$$is_range) {
        return false;
      }

      return self.exclude === other.exclude &&
             self.begin   ==  other.begin &&
             self.end     ==  other.end;
    }
  end

  def ===(value)
    include? value
  end

  def cover?(value)
    beg_cmp = (@begin <=> value)
    return false unless beg_cmp && beg_cmp <= 0
    end_cmp = (value <=> @end)
    if @exclude
      end_cmp && end_cmp < 0
    else
      end_cmp && end_cmp <= 0
    end
  end

  def each(&block)
    return enum_for :each unless block_given?

    %x{
      var i, limit;

      if (#@begin.$$is_number && #@end.$$is_number) {
        if (#@begin % 1 !== 0 || #@end % 1 !== 0) {
          #{raise TypeError, "can't iterate from Float"}
        }

        for (i = #@begin, limit = #@end + #{@exclude ? 0 : 1}; i < limit; i++) {
          block(i);
        }

        return self;
      }

      if (#@begin.$$is_string && #@end.$$is_string) {
        #{@begin.upto(@end, @exclude, &block)}
        return self;
      }
    }

    current = @begin
    last    = @end

    while (current <=> last) < 0
      yield current

      current = current.succ
    end

    yield current if !@exclude && current == last

    self
  end

  def eql?(other)
    return false unless Range === other

    @exclude === other.exclude_end? &&
    @begin.eql?(other.begin) &&
    @end.eql?(other.end)
  end

  def exclude_end?
    @exclude
  end

  def first(n=(n_specified=true; nil))
    return @begin if n_specified
    super
  end

  alias :include? :cover?

  def last(n=(n_specified=true; nil))
    return @end if n_specified
    to_a.last(n)
  end

  # FIXME: currently hardcoded to assume range holds numerics
  def max
    if block_given?
      super
    elsif @begin > @end
      nil
    elsif @exclude && @begin == @end
      nil
    else
      `#@exclude ? #@end - 1 : #@end`
    end
  end

  alias :member? :cover?

  def min
    if block_given?
      super
    elsif @begin > @end
      nil
    elsif @exclude && @begin == @end
      nil
    else
      @begin
    end
  end

  def size
    _begin = @begin
    _end   = @end
    _end  -= 1 if @exclude

    return nil unless Numeric === _begin && Numeric === _end
    return 0 if _end < _begin
    infinity = Float::INFINITY
    return infinity if infinity == _begin.abs || _end.abs == infinity

    (`Math.abs(_end - _begin) + 1`).to_i
  end

  def step(n = 1)
    return enum_for(:step, n) unless block_given?
    raise ArgumentError.new("step can't be negative") if n < 0
    raise ArgumentError.new("step can't be 0") unless n > 0
    if @begin.is_a?(Numeric) and @end.is_a?(Numeric)
      i = 0
      loop do
        current = @begin + i * n
        if @exclude
          break if current >= @end
        else
          break if current > @end
        end
        yield(current)
        i += 1
      end
    else
      raise TypeError, "step must be an integer" unless n.is_a?(Numeric) && n.to_int == n
      i = 0
      each do |value|
        yield(value) if i % n == 0
        i += 1
      end
    end
    self
  end

  def bsearch(&block)
    return enum_for(:bsearch) unless block_given?
    unless @begin.is_a?(Numeric) && @end.is_a?(Numeric)
      raise TypeError.new("can't do binary search for #{@begin.class}")
    end
    to_a.bsearch(&block)
  end

  def to_s
    "#{@begin}#{ @exclude ? '...' : '..' }#{@end}"
  end

  def inspect
    "#{@begin.inspect}#{ @exclude ? '...' : '..' }#{@end.inspect}"
  end

  def marshal_load(args)
    @begin = args[:begin]
    @end = args[:end]
    @exclude = args[:excl]
  end

  def hash
    [@begin, @end, @exclude].hash
  end
end
