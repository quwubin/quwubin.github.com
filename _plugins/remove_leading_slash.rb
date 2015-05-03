module Jekyll
	module RemoveLeadingSlash

		def remove_leading_slash(site_url, following_url=nil)
			if site_url == '/'
				''
			else
				unless following_url.to_s.start_with?("/")
					site_url.sub(/\/$/, '')
				else
					site_url
				end
			end
			
		end

	end
end

Liquid::Template.register_filter(Jekyll::RemoveLeadingSlash)
