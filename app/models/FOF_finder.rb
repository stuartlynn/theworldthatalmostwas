
class FOF_finder 
  attr_accessor :data, :chains, :tolerance, :points, :clusters_on, :consensus_on
  
  
  def initialize(data, tolerance)
    self.chains = data.collect{|d| [d] }
    self.points = self.chains.clone
    self.tolerance = tolerance
  end
  
  def reset_chains 
   self.chains=self.points.clone
  end 
  
  
  def update_chains(*arg_hash)
      opts=arg_hash.extract_options! 
      i=0
      done = true
      
      while i < chains.size do 
        j=i+1
        while j<chains.size do
        if compare_chains(chains[i],chains[j],opts)
          chains[i] = chains[i] | chains[j]
          chains.delete_at j 
          j=j-1
          done=false 
        end 
        j=j+1
      end
      i=i+1
    end
    
    done 
  end
  
  
  
  def find_groups(*arg_hash)
    self.chains = self.points.clone
    opts=arg_hash.extract_options! 
    done = false  
    while !self.update_chains(opts)
    end
    chains 
  end

  def compare_chains(chain1,chain2,*arg_hash) 
    opts=arg_hash.extract_options! 
    joined = false
    chain1.each do |part1|
      chain2.each do |part2|
        if self.dist(part1, part2,opts) < tolerance
          return true 
        end
      end
    end
    return false
  end
  
  def dist(point1,point2,*arg_hash)
    
    opts=arg_hash.extract_options! 
    val =0
    if opts and opts[:cluster_on]
      clusters_on = opts[:cluster_on] 
    else
      clusters_on = chains.first.first.keys
    end
    
    if opts and opts[:weights]
      weights = opts[:weights]
    else
      weights = {}
    end
    
    clusters_on.each{|key| weights[key] ||= 1} #fill in missing weights
    
    clusters_on.each do |key|
      val = val + ( (point1[key] - point2[key] ) * weights[key] )**2 
    end
    val =Math.sqrt(val.abs)
  end
  
  def chains_to_string
    s=""
    chains.each_with_index do |c,i|
      data= c.collect{|data| data.to_a}
      s<<"#{data},"
    end
    s
  end
  
  def chains_to_csv
    s=""
    chains.each_with_index do |c,chain_no|
      c.each do |data|
        s<<"#{chain_no}, #{data.to_csv}"
      end
      s<<"\n\n"
    end
    s
  end
  

  def centers(*arg_hash)
    opts=arg_hash.extract_options!
    if opts[:centers_in_coords]
      coords = opts[:centers_in_coords] 
    else
      coords = chains.first.first.keys
    end
    centers=[]
    chains.each do |chain| 
      ave = coords.each.inject({}){|r,v| r[v] = 0.0;r }
      chain.each do |point|
        coords.each{|key| ave[key]+=point[key] }
      end
      no_points_in_chain = chain.count.to_f
      centers<<ave.keys.inject({}){|r,key| r[key]= ave[key]/no_points_in_chain; r}
    end
    centers
  end
  
  def chains_to_json
    data=[]
    chains.each_with_index do |c,i|
      data<< c.collect{|data| data.to_a}
    end
    data.to_json
  end
  
  def add_point(point)
    chains <<[point]
    while !self.update_chains
    end
    chains
  end

  def consensus(*arg_hash)
    opts=arg_hash.extract_options! 
    
    results=[];
    
    with_feedback=opts[:feedback] || false 
    
    if opts[:consensus_on]
      consensus_on = opts[:consensus_on]
    else 
      consensus_on = self.chains.first.first.keys
    end
    

    chains.each do |chain|
      counts = consensus_on.inject({}){|r,key| r[key] = {} ; r}
      chain.each do |point|
        consensus_on.each do |key|
          counts[key][point[key]] ||=0
          counts[key][point[key]]+=1
        end
      end
      if with_feedback
        result = consensus_on.inject({}){|r,key| val= counts[key].invert.max[1];
                                                 total = counts[key].values.sum.to_f;
                                                         r[key]={ :value => val,
                                                         :confidence=>counts[key][val].to_f/total}; r 
                                        }
      else 
        result = consensus_on.inject({}){|r,key| r[key]=counts[key].invert.max[1]; r }
      end
      results << result
    end
    results
  end

# def plotChains(out_file,chains)
#   Gnuplot.open do |gp|
#     Gnuplot::Plot.new( gp ) do |plot|
# 
#      
#       plot.title  out_file
# 
#       plot.xlabel "x"
#       plot.ylabel "y"
#       
#       plot.term "png"
#       plot.output out_file
#       object_counter =1
#       
#       plot.xrange "[0:606]"
#       plot.yrange "[0:943]"
#       #   
#       chains.each_with_index do |chain, chain_index|
#         puts chain.to_json
#         puts "\n\n"
#         xdata= chain.collect{|c| c[0]+235}
#         ydata= chain.collect{|c| c[1]+131}
#         plot.data << Gnuplot::DataSet.new( [xdata,ydata] ) do |ds|
#           ds.with = "p"
#         end
#       end
# 
#     end
# 
end

