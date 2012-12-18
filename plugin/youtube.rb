#  (c) Etienne Rossignon 
#  Licence : MIT
#  
#  this liquid plugin insert a embeded youtube video to your octopress or Jekill blog
#  using the following syntax:
#    {% youtube ABCDEF123  %}
#
#  this plugin has been designed to optimize loading time when many youtube videos
#  are inserted to a single page by delaying the youtube <iframe>'s until the user
#  click on the thumbnail image of the video.
#  
#  Special care have been taken to make sure tha the video resizes properly when 
#  the webbrowser page width changes, or on smartphones. 
#  
#   
#
#  a jsfiddle to experiment the lazy loading process can be found at : 
#        http://jsfiddle.net/erossignon/3DZ6f
#
# credits: 
#   responsive video : 
#       https://github.com/optikfluffel/octopress-responsive-video-embed
#       http://andmag.se/2012/10/responsive-images-lazy-load-and-multiserve-images/
#   lazy loading:
#       http://jsfiddle.net/mUqNj/ and http://yabtb.blogspot.com/2011/12/lazy-load-youtube-videos.html
#   jekyll plugin:
#       http://makokal.github.com/blog/2012/02/24/simple-jekyll-plugin-for-youtube-videos/
#       https://gist.github.com/1805814
#   
require 'json'
require 'erb'

class YouTube < Liquid::Tag
  Syntax = /^\s*([^\s]+)(\s+(\d+)\s+(\d+)\s*)?/
  Cache = Hash.new

  def initialize(tagName, markup, tokens)
    super

    if markup =~ Syntax then
      @id = $1

      if $2.nil? then
          @width = 560
          @height = 315 
      else
          @width = $2.to_i
          @height = $3.to_i
      end
    else
      raise "No YouTube ID provided in the \"youtube\" tag"
    end
  end

  def render(context)

    if ( Cache.has_key?(@id)) then 
        return Cache[@id]
    end

    # extract video information using a REST command 
    response = Net::HTTP.get_response("gdata.youtube.com","/feeds/api/videos/#{@id}?v=2&alt=jsonc")
    data = response.body
    result = JSON.parse(data)

    # if the hash has 'Error' as a key, we raise an error
    if result.has_key? 'Error'
        puts "web service error or invalid video id"
    end

    # extract the title and description from the json string
    @title = result["data"]["title"]
    @description = result["data"]["description"]

    puts " title #{@title}"

    @style = "width:100%;height:100%;background:#000 url(http://i2.ytimg.com/vi/#{@id}/0.jpg) center center no-repeat;background-size:contain;position:absolute" 
    
    @emu = "http://www.youtube.com/embed/#{@id}?autoplay=1"

    @videoFrame =  CGI.escapeHTML("<iframe style=\"vertical-align:top;width:100%;height:100%;position:absolute;\" src=\"#{@emu}\" frameborder=\"0\" allowfullscreen></iframe>")
 
    # with jQuery 
    #@onclick    = "$('##{@id}').replaceWith('#{@videoFrame}');return false;"
 
    # without JQuery
    @onclick    = "var myAnchor = document.getElementById('#{@id}');" + 
                  "var tmpDiv = document.createElement('div');" +  
                  "tmpDiv.innerHTML = '#{@videoFrame}';" + 
                  "myAnchor.parentNode.replaceChild(tmpDiv.firstChild, myAnchor);"+
                  "return false;" 

   # note: so special care is required to produce html code that will not be massage by the 
   #       markdown processor :
   #       extract from the markdown doc :  
   #           'The only restrictions are that block-level HTML elements � e.g. <div>, <table>, <pre>, <p>, etc. 
   #            must be separated from surrounding content by blank lines, and the start and end tags of the block
   #            should not be indented with tabs or spaces. '
   result = <<-EOF

<div class="ratio-4-3 embed-video-container" onclick="#{@onclick}" title="click here to play">
<a class="youtube-lazy-link" style="#{@style}" href="http://www.youtube.com/watch?v=#{@id}" id="#{@id}" onclick="return false;">
<div class="youtube-lazy-link-div"></div>
<div class="youtube-lazy-link-info">#{@title}</div>
</a>
<div class="video-info" >#{@description}</div>
</div>

EOF
  Cache[@id] = result
  return result

  end

  Liquid::Template.register_tag "youtube", self
end
