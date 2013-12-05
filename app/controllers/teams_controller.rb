class TeamsController < ApplicationController
  before_action :parse_xml, only: [:standings]
  before_action :parse_xml2, only: [:shield]
  helper_method :sort_column, :sort_direction
  
  def standings
    @teams = Team.order(sort_column + " " + sort_direction)
  end

  def parse_xml
  	  @doc = Nokogiri::XML(File.open("srml-98-2013-standings.xml"))

	  teamRef = @doc.xpath("//@TeamRef")
	  points = @doc.xpath("//Points")
	  played = @doc.xpath("//Played")
	  won = @doc.xpath("//Won")
	  lost = @doc.xpath("//Lost")
	  ties = @doc.xpath("//Drawn")
	  goalsFor = @doc.xpath("//For")
	  goalsAgainst = @doc.xpath("//Against")
	  homeFor = @doc.xpath("//HomeFor")
	  homeAgainst = @doc.xpath("//HomeAgainst")
	  awayFor = @doc.xpath("//AwayFor")
	  awayAgainst = @doc.xpath("//AwayAgainst")

	def getName(nRef)
	    name = @doc.xpath("//Team[@uID='"+nRef+"']/Name")
	    name[0].content.to_s
  	end

  	@confs = {eastern: [], western: []}

	(0...teamRef.length).each do |i|
		if i<10
		@confs[:eastern] << {
			getName(teamRef[i]).parameterize.underscore.to_sym => {
			id: i+1, 
			name: getName(teamRef[i]).to_s,
			points: points[i].content.to_f, 
		  	played: played[i].content.to_f,
		  	won: won[i].content.to_i,
		  	lost: lost[i].content.to_i,
		  	ties: ties[i].content.to_i,
		  	gFor: goalsFor[i].content.to_i,
		  	gAgt: goalsAgainst[i].content.to_i,
		  	homeFor: homeFor[i].content.to_i,
		  	homeAgt: homeAgainst[i].content.to_i,
		  	awayFor: awayFor[i].content.to_i,
		  	awayAgt: awayAgainst[i].content.to_i
	  	 	}
	  	}
	    else 
			@confs[:western] << {
			getName(teamRef[i]).parameterize.underscore.to_sym => { 
			id: i-9,
			name: getName(teamRef[i]).to_s,
			points: points[i].content.to_f, 
		  	played: played[i].content.to_f,
		  	won: won[i].content.to_i,
		  	lost: lost[i].content.to_i,
		  	ties: ties[i].content.to_i,
		  	gFor: goalsFor[i].content.to_i,
		  	gAgt: goalsAgainst[i].content.to_i,
		  	homeFor: homeFor[i].content.to_i,
		  	homeAgt: homeAgainst[i].content.to_i,
		  	awayFor: awayFor[i].content.to_i,
		  	awayAgt: awayAgainst[i].content.to_i
	  	 	}
	  	}
	  end
	end


@magicNoE=0 
@magicNoW=0 

@confs.each do |key, value| 
  value.each do |l, m| 
    l.each do |k,v| 
      if v[:id]==6 && key==:eastern 
        @magicNoE = v[:points]+((34-v[:played])*3) 
      elsif v[:id]==6 && key==:western 
        @magicNoW = v[:points]+((34-v[:played])*3) 
      end
    end
  end
end

  end

  def parse_xml2
  	@doc = Nokogiri::XML(File.open("srml-98-2013-standings.xml"))

	  teamRef = @doc.xpath("//@TeamRef")
	  points = @doc.xpath("//Points")
	  played = @doc.xpath("//Played")
	  won = @doc.xpath("//Won")
	  lost = @doc.xpath("//Lost")
	  ties = @doc.xpath("//Drawn")
	  goalsFor = @doc.xpath("//For")
	  goalsAgainst = @doc.xpath("//Against")
	  homeFor = @doc.xpath("//HomeFor")
	  homeAgainst = @doc.xpath("//HomeAgainst")
	  awayFor = @doc.xpath("//AwayFor")
	  awayAgainst = @doc.xpath("//AwayAgainst")

	def getName(nRef)
	    name = @doc.xpath("//Team[@uID='"+nRef+"']/Name")
	    name[0].content.to_s
  	end

  	@confs = {teams: []}

  		(0...teamRef.length).each do |i|
		@confs[:teams] << {
			getName(teamRef[i]).parameterize.underscore.to_sym => {
			id: i+1, 
			name: getName(teamRef[i]).to_s,
			points: points[i].content.to_f, 
		  	played: played[i].content.to_f,
		  	won: won[i].content.to_i,
		  	lost: lost[i].content.to_i,
		  	ties: ties[i].content.to_i,
		  	gFor: goalsFor[i].content.to_i,
		  	gAgt: goalsAgainst[i].content.to_i,
		  	homeFor: homeFor[i].content.to_i,
		  	homeAgt: homeAgainst[i].content.to_i,
		  	awayFor: awayFor[i].content.to_i,
		  	awayAgt: awayAgainst[i].content.to_i
	  	 	}
	  	}
	  	end
  end

  private
  
  def sort_column
    Team.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
 
end
