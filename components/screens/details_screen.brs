


sub init()
  m.title = m.top.FindNode("title")
  m.release = m.top.FindNode("release")
  m.rating = m.top.FindNode("rating")
  m.background = m.top.FindNode("background")
  m.description = m.top.FindNode("description")
  m.thumbnail = m.top.FindNode("thumbnail")
  m.play_button = m.top.FindNode("play_button")
  m.top.observeField("visible", "onVisibleChange")
  m.play_button.setFocus(true)
end sub

' set proper focus to rowList in case if return from Details Screen
sub onVisibleChange()
  if m.top.visible = true then
    ' m.play_button.setFocus(true)
  end if
end sub

sub OnContentChange(obj)
  item = obj.getData()
  m.background.uri = item.SecondaryTitle
  m.title.text = item.title
  m.release.text = "Release Date: " + item.releaseDate
  m.rating.text = "Rating: " + item.rating
  m.description.text = item.description
  m.thumbnail.uri = item.HDGRIDPOSTERURL
end sub
