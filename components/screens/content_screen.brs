sub init()
  m.content_grid = m.top.FindNode("content_grid")
  m.top.observeField("visible", "onVisibleChange")
	

end sub

sub onVisibleChange ()
  if m.top.visible = true then
    m.content_grid.setFocus(true)
  end if
end sub

sub onFeedChanged(obj)
    feed = obj.getData()
    ?"feed"; feed
    ' m.header.text = feed.title
    postercontent = createObject("roSGNode","ContentNode")
    for each item in feed.results
		node = createObject("roSGNode","ContentNode")
    dateString =  item.release_date
    yearString = " (" + Mid(dateString, 1, 4) + ")"' Extract the first 4 characters (year) from the string
	    node.id = item.id
	    node.title = item.title + yearString
      node.releaseDate = item.release_date
      ?"item.backdrop_path"; item.backdrop_path
      if item.backdrop_path = invalid
        node.SecondaryTitle = ""
      else
        node.SecondaryTitle = "https://image.tmdb.org/t/p/original" + item.backdrop_path
      end if
      ?"secondaryTitle"; node.secondaryTitle
	    ' node.url = item.url
	     node.description = item.overview

       if item.backdrop_path = invalid
        node.HDGRIDPOSTERURL = "pkg:/images/No-Image-Placeholder.png"
      else
        node.HDGRIDPOSTERURL = "https://image.tmdb.org/t/p/original" + item.poster_path
      end if
      
      ' node.HDGRIDPOSTERURL = "https://image.tmdb.org/t/p/original" + item.poster_path
      node.rating = (Cint((item.vote_average) * 10)).ToStr() + "%"
	    node.SHORTDESCRIPTIONLINE1 = item.title
		  node.SHORTDESCRIPTIONLINE2 = "Rating: " + node.rating 
	  '   node.HDGRIDPOSTERURL = item.thumbnail
	  '   node.SHORTDESCRIPTIONLINE1 = item.title
		' node.SHORTDESCRIPTIONLINE2 = item.description
	    postercontent.appendChild(node)
    end for
    showpostergrid(postercontent)
end sub

sub showpostergrid(content)
  m.content_grid.content=content
  m.content_grid.visible=true
  ' m.content_grid.setFocus(true)
end sub
