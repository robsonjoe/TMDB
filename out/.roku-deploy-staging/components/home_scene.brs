function init()
	? "[home_scene] init"
	m.top.backgroundURI = ""
	m.top.backgroundColor = "0xFFFFFFFF"
	m.category_screen = m.top.findNode("category_screen")
	m.content_screen = m.top.findNode("content_screen")
	m.search_screen = m.top.findNode("search_screen")
	m.details_screen = m.top.findNode("details_screen")
	m.error_dialog = m.top.findNode("error_dialog")
	m.videoplayer = m.top.findNode("videoplayer")
	m.header = m.top.FindNode("header")
	m.movieButton = m.top.findNode("movieButton")
	m.dialogBackground = m.top.findNode("dialogBackgroundPoster")
	m.popupTitleLabel = m.top.findNode("popupTitleLabel")
	m.miniKeyboard = m.top.findNode("miniKeyboard")
	m.tmdbbannerimage=m.top.findNode("tmdbbannerimage")
	randomBanner()
    ' m.tmdbbannerimage.uri = "pkg:/images/tmdbbanner" + (RND(9)).toStr() + ".png"
    ?"image "; m.tmdbbannerimage

	initializeVideoPlayer()

	
	m.category_screen.observeField("header_selected", "onHeaderSelected")
	m.content_screen.observeField("content_selected", "onContentSelected")
	m.details_screen.observeField("play_button_pressed", "onPlayButtonPressed")
	m.movieButton.observeField("buttonSelected", "onMovieButtonSelected")
	m.miniKeyboard.observeField("text", "onKeyboardTextChange")
	
	hideKeyboard()
	' m.searchBanner = m.top.findNode("tmdbbannerimage")
	m.defaultLoad = "popular"
	loadFeed (m.defaultLoad)
	m.posterGrid = m.top.FindNode("header_list")
	m.contentGrid = m.top.FindNode("content_grid")
    m.postergridcontent = createObject("roSGNode","ContentNode")
    m.postercontent = createObject("roSGNode","ContentNode")

	setupmenu()
	' m.category_screen.setFocus(true)
end function

sub initializeVideoPlayer()
	m.videoplayer.EnableCookies()
	m.videoplayer.setCertificatesFile("common:/certs/ca-bundle.crt")
	m.videoplayer.InitClientCertificates()
	'set position notification to 1 second
	m.videoplayer.notificationInterval=1
	m.videoplayer.observeFieldScoped("position", "onPlayerPositionChanged")
	m.videoplayer.observeFieldScoped("state", "onPlayerStateChanged")
end sub

sub randomBanner()
	m.tmdbbannerimage.uri = "pkg:/images/tmdbbanner" + (RND(13)).toStr() + ".png"
end sub

sub showKeyboard()
	m.miniKeyboard.textEditBox.text = ""
	m.dialogBackground.visible = true
	m.popupTitleLabel.visible = true
	m.miniKeyboard.visible = true
	m.miniKeyboard.setFocus(true)
end sub

Sub hideKeyboard()
	m.dialogBackground.visible = false
	m.miniKeyboard.visible = false
	m.popupTitleLabel.visible = false
	m.miniKeyboard.setFocus(false)
end sub

sub setupmenu()

	popular = createObject("roSGNode","ContentNode")
    popular.hdgridposterurl = "pkg:/images/popular.png"
	popular.id = "popular"
    ' popular.shortdescriptionline1 = "https://api.themoviedb.org/3/movie/popular?api_key=b69145796c919e97d21879a2808340e3&language=en-US&page=1"
	popular.shortdescriptionline1 = "popular"

	popular.w = 1
    popular.h = 1
    popular.x = 0
    popular.y = 0
    m.postergridcontent.appendChild(popular)

	nowplaying = createObject("roSGNode","ContentNode")
    nowplaying.hdgridposterurl = "pkg:/images/nowplaying.png"
    nowplaying.id = "nowplaying"
	' nowplaying.shortdescriptionline1 = "https://api.themoviedb.org/3/movie/now_playing?api_key=b69145796c919e97d21879a2808340e3&language=en-US&page=1"
	nowplaying.shortdescriptionline1 = "now_playing"

	nowplaying.w = 1
    nowplaying.h = 1
    nowplaying.x = 1
    nowplaying.y = 0
	? "nowplaying" ; nowplaying
    m.postergridcontent.appendChild(nowplaying)

	upcoming = createObject("roSGNode","ContentNode")
    upcoming.hdgridposterurl = "pkg:/images/upcoming.png"
	upcoming.id = "upcoming"
    ' upcoming.shortdescriptionline1 = "https://api.themoviedb.org/3/movie/upcoming?api_key=b69145796c919e97d21879a2808340e3&language=en-US&page=1"
	upcoming.shortdescriptionline1 = "upcoming"

	upcoming.w = 1
    upcoming.h = 1
    upcoming.x = 2
    upcoming.y = 0
    m.postergridcontent.appendChild(upcoming)

	toprated = createObject("roSGNode","ContentNode")
    toprated.hdgridposterurl = "pkg:/images/toprated.png"
	toprated.id = "toprated"
    ' toprated.shortdescriptionline1 = "https://api.themoviedb.org/3/movie/top_rated?api_key=b69145796c919e97d21879a2808340e3&language=en-US&page=1"
	toprated.shortdescriptionline1 = "top_rated"

	toprated.w = 1
    toprated.h = 1
    toprated.x = 3
    toprated.y = 0
    m.postergridcontent.appendChild(toprated)

	m.posterGrid.ObserveField("itemSelected", "handleBtnPress")
    m.posterGrid.content = m.postergridcontent
    m.posterGrid.visible = true
    m.posterGrid.setFocus(true)

end sub

sub onHeaderSelected(obj)
    ? "onCategorySelected field: ";obj.getField()
    ? "onCategorySelected data: ";obj.getData()
    list = m.category_screen.findNode("header_list")
    ? "onCategorySelected checkedItem: ";list.checkedItem
    ? "onCategorySelected selected ContentNode: ";list.content.getChild(obj.getData())
    item = list.content.getChild(obj.getData())
	?"item : ";item
	m.content_screen.visible = true
	m.search_screen.visible = true
	m.details_screen.visible = false
	m.posterGrid.setFocus(true)
	m.header.text = Ucase(item.SHORTDESCRIPTIONLINE1.Replace("_", " "))
	' title = Ucase(url)
	' m.header.text = item.SHORTDESCRIPTIONLINE1
    loadFeed(item.SHORTDESCRIPTIONLINE1)
end sub

function onMovieButtonSelected()
	showKeyboard()
end function

function onKeyboardTextChange(event) as void
	text = event.getData()
	
	 ?"keyboard text: ";m.miniKeyboard.textEditBox.text	 
end function

function formatSearch(text)
	m.searchtext = text
	m.searchtext = "&query=" + m.searchtext.Replace(" ", "+")
	?"m.searchtext =";  m.searchtext
	return m.searchtext
end function

sub onContentSelected(obj)
	selected_index = obj.getData()
	m.selected_media = m.content_screen.findNode("content_grid").content.getChild(selected_index)
	m.details_screen.content = m.selected_media
	m.content_screen.visible = false
	m.search_screen.visible = false
	m.details_screen.visible = true
	m.posterGrid.setFocus(true)
end sub

sub onPlayButtonPressed(obj)
	m.details_screen.visible = false
	m.videoplayer.visible = true
	m.videoplayer.setFocus(true)
	m.videoplayer.content = m.selected_media
	m.videoplayer.control = "play"
end sub

sub loadFeed(url)
  
  if Mid(url, 1, 7) = "&query="
	m.fullUrl = "https://api.themoviedb.org/3/search/movie?&api_key=b69145796c919e97d21879a2808340e3" + url + "&sort_by=popularity.desc"
  else 
	m.fullUrl = "https://api.themoviedb.org/3/movie/" + url + "?api_key=b69145796c919e97d21879a2808340e3"
  end if

'   m.header.text = Ucase(url.Replace("_", " "))
	' title = Ucase(url)
  
  m.feed_task = createObject("roSGNode", "load_feed_task")
  'should add error field, too
  m.feed_task.observeField("response", "onFeedResponse")
  m.feed_task.url = m.fullUrl
  m.feed_task.control = "RUN"
end sub

sub onFeedResponse(obj)
	response = obj.getData() 'this is a string from the http response
	'turn the string (JSON) into an Associative Array

	data = parseJSON(response)
	?"data" ; data 
	if data <> Invalid and data.results <> invalid
		'hide the category_screen, show the content_screen
		m.category_screen.visible = true
		m.content_screen.visible = true
		' assign data to content screen
		m.content_screen.feed_data = data
	else
		? "FEED RESPONSE IS EMPTY! LAME."
	end if
end sub

sub onPlayerPositionChanged(obj)
	? "Player Position: ", obj.getData()
end sub

sub onPlayerStateChanged(obj)
  state = obj.getData()
	? "onPlayerStateChanged: ";state
	if state="error"
    	showErrorDialog(m.videoplayer.errorMsg+ chr(10) + "Error Code: "+m.videoplayer.errorCode.toStr())
	else if state = "finished"
		closeVideo()
	end if
end sub

sub closeVideo()
	m.videoplayer.control = "stop"
	m.videoplayer.visible=false
	m.details_screen.visible=true
end sub

sub showErrorDialog(message)
	m.error_dialog.title = "ERROR"
	m.error_dialog.message = message
	m.error_dialog.visible=true
	'tell the home scene to own the dialog so the remote behaves'
	m.top.dialog = m.error_dialog
end sub

' Main Remote keypress handler
	function onKeyEvent(key, press) as Boolean
		? "[home_scene] onKeyEvent", key, press
		if key = "up" and press
			if m.contentGrid.hasFocus()
				m.movieButton.setFocus(true)
				m.category_screen.visible=true
				' m.content_screen.visible=true
				return true
			else if m.movieButton.hasFocus()
				m.posterGrid.setFocus(true)
				return true
			end if
		else if key ="down" and press
			if m.posterGrid.hasFocus()
				m.movieButton.setFocus(true)
				' m.content_screen.visible=true
				return true
			else if m.movieButton.hasFocus()
				m.contentGrid.setFocus(true)
				return true
			end if
		end if
		' we must capture the 'true' for press, it comes first (true=down,false=up) to keep the firmware from handling the event
		if key = "back" and press
			if m.details_screen.visible
				randomBanner()
				m.search_screen.visible = true
				m.details_screen.visible=false
				m.content_screen.visible=true
				return true
			else if m.miniKeyboard.visible = true
				if m.miniKeyboard.textEditBox.text = ""
					randomBanner()
					m.search_screen.visible = true
					m.details_screen.visible=false
					m.content_screen.visible=true
				else 
					? "textbox2"; m.miniKeyboard.textEditBox.text
					search = formatSearch(m.miniKeyboard.textEditBox.text)
					m.header.text = "SEARCH RESULTS..."
					loadFeed(search)
				end if
				hideKeyboard()
				
				m.contentGrid.setFocus(true)
				return true	
			else if m.videoplayer.visible
				closeVideo()
				return true
			end if
		end if
	return false
	end function
