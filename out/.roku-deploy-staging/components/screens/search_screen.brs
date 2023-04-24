function init()
    ' m.header_list=m.top.findNode("header_list")
      ' m.header_list.setFocus(true)
    '   m.tmdbbannerimage=m.top.findNode("tmdbbannerimage")
    '   m.tmdbbannerimage = "pkg:/images/tmdbbanner" + (RND(9)).toStr() + ".png"
    '   ?"image "; m.tmdbbannerimage
      m.top.observeField("visible", "onVisibleChange")
  end function
  
  ' set proper focus to rowList in case if return from Details Screen
  sub onVisibleChange()
    if m.top.visible = true then
    '   m.header_list.setFocus(true)
    end if
  end sub