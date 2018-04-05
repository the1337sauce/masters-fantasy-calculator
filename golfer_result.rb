class GolferResult
  attr_reader :r1, :r2, :r3, :r4, :to_par, :pos, :name, :thru, :today

  def initialize response_hash
    @r1 = response_hash['r1']
    @r2 = response_hash['r2']
    @r3 = calculate_round3(response_hash)
    @r4 = calculate_round4(response_hash)
    @to_par = response_hash['to_par']
    @pos = response_hash['pos']
    @thru = response_hash['thru']
    @name = response_hash['player']
    @today = calculate_today(response_hash)
    if @name.eql? "Sean O&#39;Hair"
      @name = "Sean O'Hair"
    end
  end

  def calculate_today response_hash
    response_hash['thru'] == 'CUT' ? 80 : response_hash['today'].to_i
  end

  def calculate_round3 response_hash
    response_hash['thru'] == 'CUT' ? 80 : response_hash['r3'].to_i
  end

  def calculate_round4 response_hash
    response_hash['thru'] == 'CUT' ? 80 : response_hash['r4'].to_i
  end

  def last_name
    @name.split(' ')[1]
  end

  def cut?
    @to_par.eql? 'CUT'
  end

  def to_s
    "#{@name} currently #{@to_par}, today: #{@today}"
  end

end
