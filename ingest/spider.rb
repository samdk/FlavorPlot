class Spider
	def spider
		while next? 
			yield next_recipe
		end 
	end
end
