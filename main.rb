# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity

module Enumerable
  # 1-- Defining my_each method
  def my_each
    return to_enum(:my_each) unless block_given?

    i = 0
    while i < to_a.length
      yield to_a[i]
      i += 1
    end
    self
  end

  # 2-- Defining my_each_with_index
  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    i = 0
    while i < to_a.length
      yield(to_a[i], i)
      i += 1
    end
    self
  end

  # 3--Defining my_select
  def my_select
    return to_enum(:my_select) unless block_given?

    new_arr = []
    to_a.each { |x| new_arr << x if yield x }
    new_arr
  end

  # 4-- Defining my_all?
  def my_all?(arg = nil)
    arr = self
    if block_given?
      arr.my_each { |x| return false if yield(x) == false }
      return true
    elsif !block_given? && arg.nil?
      arr.my_each { |x| return false if x.nil? || x == false }
    elsif arg.is_a?(Class)
      arr.my_each { |x| return false unless x.is_a?(arg) }
    elsif arg.is_a?(Regexp)
      arr.my_each { |x| return false unless arg.match(x) }
    else
      arr.my_each { |x| return false if x != arg }
    end
    true
  end

  # 5-- Defining my_any?
  def my_any?(arg = nil)
    arr = self
    if block_given?
      arr.my_each { |x| return true if yield x }
    elsif !block_given? && arg.nil?
      arr.my_each { |x| return true unless x.nil? || x == false }
    elsif arg.is_a?(Class)
      arr.my_each { |x| return true if x.is_a?(arg) }
    elsif arg.is_a?(Regexp)
      arr.my_each { |x| return true if arg.match(x) }
    else
      arr.my_each { |x| return true if x == arg }
    end
    false
  end

  # 6-- Defining my_none?
  def my_none?(arg = nil)
    arr = self
    return !arr.my_any?(arg) unless block_given?

    arr.my_each { |x| return false if yield x }
    true
  end

  # 7-- Defining my_count?
  def my_count(param = nil)
    c = 0
    if block_given?
      to_a.my_each { |x| c += 1 if yield x }
    elsif !block_given? && param.nil?
      c = to_a.length
    else
      c = to_a.my_select { |x| x == param }.length
    end
    c
  end

  # 8-- Defining my_maps
  def my_map(arg = nil)
    return to_enum(:my_map) unless block_given?

    index = 0
    n_array = []
    while index < to_a.length
      n_array[index] = arg.nil? ? yield(to_a[index]) : !yield(to_a[index])
      index += 1
    end
    n_array
  end

  # 9-- Defining my_inject
  def my_inject(arg1 = nil, arg2 = nil)
    if (!arg1.nil? && arg2.nil?) && (arg1.is_a?(Symbol) || arg1.is_a?(String))
      arg2 = arg1
      arg1 = nil
    end
    if !block_given? && !arg2.nil?
      my_each { |ele| arg1 = arg1.nil? ? ele : arg1.send(arg2, ele) }
    else
      my_each { |ele| arg1 = arg1.nil? ? ele : yield(arg1, ele) }
    end
    arg1
  end
end

# 10-- multiply_els
def multiply_els(elements)
  elements.my_inject(:*)
end
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
