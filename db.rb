class Db
  attr_accessor :data
  
  def initialize(file=nil)
    # Should be in the format {ingredient => {ingredient => weight, ...}, ... }
    @data = file ? Marshal.load(File.open(file)) : {}
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
    @data[int2][int]  += 1
  end
  
  def save(file=nil)
    Marshal.dump @data, File.open(file || @file, 'w')
  end
end