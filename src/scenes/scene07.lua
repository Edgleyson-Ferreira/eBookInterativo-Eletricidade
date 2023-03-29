local composer = require( "composer" )
 
local composer = require("composer")
local util = require('util')
local hud = require("src.hud.fixedPositions")

local physics = require("physics")

physics.start()

local scene = composer.newScene()

local nextPage
local wire
local lampOn
local lampOff
local flare
local nacl
local h2o
local clip
local vidro
local contactPosition
local isDragging = false
local draggedObj = nil

 
local function next()
    composer.gotoScene('src.scenes.scene08', {
        effect = "fade",
        time = 500
    })
end

local function prev()
    composer.gotoScene('src.scenes.scene06', {
        effect = "fade",
        time = 500
    })
end

local function moverObjeto(event)
    local objeto = event.target

    if event.phase == "began" then
        isDragging = true
        draggedObj = objeto
    elseif event.phase == "moved" then
        if isDragging and objeto == draggedObj then
            objeto.x = event.x
            objeto.y = event.y
        end
    elseif event.phase == "ended" or event.phase == "cancelled" then
        isDragging = false
        draggedObj = nil
    end
end

local function changeState(state)
    local state = state
    if state == 'on' then
        lampOn.alpha = 1
        lampOff.alpha = 0
        flare.alpha = 1
    else
        lampOn.alpha = 0
        lampOff.alpha = 1
        flare.alpha = 0
    end
    return state
end

local function handleLamp(event)
    local touchedObject = event.target
    if touchedObject.x < contactPosition.x + 10 and touchedObject.x > contactPosition.x - 10 and touchedObject.y <
        contactPosition.y + 10 and touchedObject.y > contactPosition.y - 10 then
        changeState('on')
        system.vibrate(1500)
    else
        changeState('off')
    end
end
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )

    local color = util.color
    display.setDefault("background", color(9), color(0), color(35))
 
    local sceneGroup = self.view
    local interaction = display.newGroup()

    nacl = display.newImage('src/assets/nacl.png', hud.CX, hud.CY)
    nacl.x, nacl.y = hud.CX * 0.3, hud.CY * 0.15
    nacl:scale(0.15, 0.15)
    interaction:insert(nacl)

    h2o = display.newImage('src/assets/h2o.png', hud.CX, hud.CY)
    h2o.x, h2o.y = hud.CX * 0.15, hud.CY * 0.15
    h2o:scale(0.15, 0.15)
    interaction:insert(h2o)

    clip = display.newImage('src/assets/clip.png', hud.CX, hud.CY)
    clip.x, clip.y = hud.CX * 0.15, hud.CY * 0.25
    clip:scale(0.1, 0.1)
    interaction:insert(clip)

    vidro = display.newImage('src/assets/vidro.png', hud.CX, hud.CY)
    vidro.x, vidro.y = hud.CX * 0.15, hud.CY * 0.42
    vidro:scale(0.2, 0.2)
    interaction:insert(vidro)

    wire = display.newImage('src/assets/wire.png', hud.CX, hud.CY)
    wire.x, wire.y = hud.CX * 1.1, hud.CY * 0.3
    wire:scale(0.2, 0.2)
    interaction:insert(wire)

    flare = display.newImage('src/assets/flare.png', hud.CX, hud.CY)
    flare.x, flare.y = hud.CX * 1.57, hud.CY * 0.3
    flare:scale(0.55, 0.55)
    flare.rotation = 90
    interaction:insert(flare)

    lampOn = display.newImage('src/assets/lamp-on.png', hud.CX, hud.CY)
    lampOn.x, lampOn.y = hud.CX * 1.76, hud.CY * 0.35
    lampOn:scale(0.55, 0.55)
    interaction:insert(lampOn)

    lampOff = display.newImage('src/assets/lamp-off.png', hud.CX, hud.CY)
    lampOff.x, lampOff.y = hud.CX * 1.76, hud.CY * 0.35
    lampOff:scale(0.55, 0.55)
    interaction:insert(lampOff)    

    contactPosition = display.newImage('src/assets/bequer.png', hud.CX, hud.CY)
    contactPosition.x, contactPosition.y = hud.CX * 1.05, hud.CY * 0.25
    contactPosition:scale(0.2, 0.2)
    contactPosition.alpha = 0
    interaction:insert(contactPosition)

    sceneGroup:insert(interaction)
    
    nextPage = display.newImageRect('src/assets/next_page.png', hud.btnNextWidth, hud.btnNextHeight)
    nextPage.x, nextPage.y = hud.btnNextX, hud.btnNextY
    sceneGroup:insert(nextPage)

    local contentText = display.newImage('src/assets/content-7.png', hud.textX, hud.textY)
    contentText:scale(0.50, 0.50)
    sceneGroup:insert(contentText)

    local tips = display.newImageRect('src/assets/tips-7.png', hud.tipsWidth, hud.tipsHeight)
    tips.x, tips.y = hud.tipsX, hud.tipsY
    sceneGroup:insert(tips)
    
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        turnLamp = 'off'
        changeState(turnLamp)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        nextPage:addEventListener('tap', next)
        nacl:addEventListener('touch', handleLamp)
        nacl:addEventListener('touch', moverObjeto)
        h2o:addEventListener('touch', moverObjeto)
        clip:addEventListener('touch', moverObjeto)
        clip:addEventListener('touch', handleLamp)
        vidro:addEventListener('touch', moverObjeto)
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        nextPage:removeEventListener('tap', next)
        nacl:removeEventListener('touch', handleLamp)
        nacl:removeEventListener('touch', moverObjeto)
        h2o:removeEventListener('touch', moverObjeto)
        clip:removeEventListener('touch', moverObjeto)
        clip:removeEventListener('touch', handleLamp)
        vidro:removeEventListener('touch', moverObjeto) 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene