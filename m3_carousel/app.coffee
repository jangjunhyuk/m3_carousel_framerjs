# deviceType can be either "phone" or "desktop"
Framer.DeviceView.Devices["apple-iphone-15"] =
  deviceType: "phone"
  screenWidth: 393*3
  screenHeight: 852*3
  deviceImage: "images/iphone15.png"
  deviceImageWidth: 1311
  deviceImageHeight: 2664
  devicePixelRatio: 1

# default settings
Framer.Device.deviceType = "apple-iphone-15"
Framer.Device.screen.borderRadius = 50*3
Framer.Device.background.backgroundColor = "#000"
Framer.Device.contentScale = 3
Framer.Extras.Hints.disable()	

screen_width = Screen.width 
screen_height = Screen.height

default_w = 393
default_h = 852

ratio = screen_width / default_w

Framer.Defaults.Layer.force2d = true

All = new Layer
  width: default_w  
  height: default_h 
  scale: ratio   
  originY: 0   
  y: 0  
All.centerX() 

Content = new Layer
	parent: All
	width: All.width
	height: All.height
	backgroundColor: '#fff'

# put your content below
# parent: Content 

page = new ScrollComponent
    width: Content.width - 32
    height: 180
    scrollVertical: no
    point: Align.center
    borderRadius: 20
    parent: Content

cardWidth = 60
cardHeight = 180
cardSpacing = 8

scrollcontent = new Layer
  width: (((cardWidth * 3)+cardSpacing) * 5) + cardWidth * 2
  height: cardHeight
  parent: page.content
  backgroundColor: ''

cards = []
imagebacks = []
texts = [
  "Wild Flower",
  "Classic Car",
  "Old Town Road",
  "Dessert",
  "Ferris Wheel",
  "Green Bushes"
  ]
titles = []
title_gradient = new Gradient
      start: "rgba(0,0,0, 0.4)"
      end: "transparent"
      angle: 0

for i in [0..5]
    card = new Layer
      width: cardWidth
      height: cardHeight
      backgroundColor: "lightgray"
      borderRadius: 20
      x: (cardWidth + cardSpacing) * i
      parent: scrollcontent
      clip: yes
    cards.push(card)
    
    imageback = new Layer
      width: cardWidth * 3
      height: cardHeight
      image: "images/#{i}.jpeg"
      x: -60
      parent: card 
      scale: 1.2
    imagebacks.push(imageback)

    titleback = new Layer
      parent: card
      width: cardWidth * 3
      height: cardHeight / 3
      maxY: cardHeight
      gradient: title_gradient

    title = new TextLayer
      text: texts[i]
      parent: card
      fontSize: 20
      fontWeight: 500
      x: 15
      y: cardHeight - 40
      color: '#fff'
      opacity: 0
    titles.push(title)
      
cards[0].width = 180
cards[1].width = 120
cards[5].width = 180

for i in [1..5]
  cards[i].x = cards[i-1].maxX + 8

imagebacks[0].x = 0
imagebacks[1].x = -30

titles[0].opacity = 1
titles[1].opacity = 1

page.onMove ->
  for card, i in cards
    if i < 4
      card.width = Utils.modulate page.scrollX, [card.x - 320, card.x - 60], [60, 180], yes
    if i == 4
      card.width = Utils.modulate page.scrollX, [380, 510], [60, 180], yes
      card.width = Utils.modulate page.scrollX, [510, 690], [180, 120], yes
  for i in [1..5]
    cards[i].x = cards[i-1].maxX + 8
  
  for i in [0..4]
    imagebacks[i].x = Utils.modulate cards[i].width, [60, 180], [-60, 0]
    if cards[i].x <= page.scrollX
      imagebacks[i].x = Utils.modulate page.scrollX, [cards[i].x, cards[i].x + page.scrollX], [0, 180], yes
    if i == 0
      imagebacks[i].x = Utils.modulate page.scrollX, [0, 180], [0, 60]
  imagebacks[4].x = Utils.modulate page.scrollX, [380, 510], [-40, -30], yes
  imagebacks[5].x = Utils.modulate page.scrollX, [510, 690], [-60, 0]

  for title, i in titles
    title.opacity = Utils.modulate cards[i].width, [60, 120], [0, 1]
    titles[0].opacity = Utils.modulate page.scrollX, [0, 180], [1, 0]
    titles[4].opacity = Utils.modulate page.scrollX, [380, 510], [0, 1], yes
    titles[5].opacity = Utils.modulate page.scrollX, [510, 690], [0, 1]
    if cards[i].x <= page.scrollX
      title.opacity = Utils.modulate page.scrollX, [cards[i].x, cards[i].x + page.scrollX/2], [1, 0]

# This is the layer located at the very front
notification = new Layer
  parent: Content
  width: 393
  height: 54
  image: "images/statusbar.png"
  index: 9
notification.bringToFront()

indicator = new Layer
  parent: Content
  width: 393
  height: 21
  image: "images/indicator.png"
  maxY: Content.height
indicator.bringToFront()