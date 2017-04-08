class GolferResult
  attr_reader :r1, :r2, :r3, :r4, :to_par, :pos, :name, :thru

  def initialize response_hash
    @r1 = response_hash['r1']
    @r2 = response_hash['r2']
    @r3 = response_hash['r3']
    @r4 = response_hash['r4']
    @to_par = response_hash['to_par']
    @pos = response_hash['pos']
    @name = response_hash['player']
    if @name.eql? 'Rafael Cabrera Bello'
      @name = 'Rafael Cabrera-Bello'
    end
    if @name.eql? "Sean O&#39;Hair"
      @name = "Sean O'Hair"
    end
  end

  def last_name
    @name.split(' ')[1]
  end

  def cut?
    @to_par.eql? 'CUT'
  end

  def to_s
    "#{@name} currently #{@to_par}"
  end

end
