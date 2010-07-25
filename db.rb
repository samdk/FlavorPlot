class Db
  attr_accessor :data
  
  def initialize(file=nil)
    # Should be in the format {ingredient => {ingredient => weight, ...}, ... }
    @data = file ? File.open(file) {|f| Marshal.load(f) } : {}
    @file = file
  end
  
  def get(ing, ing2=nil)
    if ing2
      @data[ing][ing2] rescue '0'
    else
      @data[ing]
    end
  end
  
  def add(ing, ing2, weight=1)
    @data[ing]       ||= {}
    @data[ing2]      ||= {}
    
    @data[ing][ing2] ||= 0
    @data[ing][ing2]  += 1
    
    @data[ing2][ing] ||= 0
    @data[ing2][ing]  += 1
  end
  
  def save(file=nil)
    File.open(file || @file, 'w') do |f|
      Marshal.dump @data, f
    end
  end
  
  def merge(from, to)
    @data[from].each_pair {|ing, weight| add(to, ing, weight) }
    @data.delete from
    @data.each_pair {|idc, ings| ings.delete from }
  end
end