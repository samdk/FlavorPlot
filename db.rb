class Db
  attr_accessor :data
  
  def initialize(file=nil)
    # Should be in the format {ingredient => {ingredient => weight, ...}, ... }
    @data = file ? File.open(file) {|f| Marshal.load(f) } : {}
    @file = file
  end
  
  def get(a, b=nil)
    if b
      (@data[a][b] || 0) rescue 0
    else
      @data[a]
    end
  end
  
  def each(&block)
    @data.each(&block)
  end
  
  def add(a, b, weight=1)
    set(a, b, get(a, b) + 1);
  end
  
  def set(a, b, v)
    @data[a] ||= {}
    @data[b] ||= {}
    
    @data[a][b] = v    
    @data[b][a] = v
  end
  
  def save(file=nil)
    File.open(file || @file, 'w') do |f|
      Marshal.dump @data, f
    end
  end
  
  def save_as(x) ; save x ; end
  
  def merge(from, to)
    @data[from].each_pair do |ing, weight|
      add(to, ing, weight)
      @data[ing].delete from
    end
    @data.delete from
  end
end