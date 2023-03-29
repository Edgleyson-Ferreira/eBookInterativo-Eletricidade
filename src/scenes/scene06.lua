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
local jumper
local jumperPosition
local flare
 
local function next()
    composer.gotoScene('src.scenes.scene07', {
        effect = "fade",
        time = 500
    })
end

local function prev()
    composer.gotoScene('src.scenes.scene05', {
        effect = "fade",
        time = 500
    })
end

local function moverObjeto(event)
    local objeto = event.target

    if objeto ~= nil then
        objeto.x = event.x
        objeto.y = event.y
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
    local touchedJumper = event.target
    if touchedJumper.x < jumperPosition.x + 10 and touchedJumper.x > jumperPosition.x - 10 and touchedJumper.y <
        jumperPosition.y + 10 and touchedJumper.y > jumperPosition.y - 10 then
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

    jumper = display.newImage('src/assets/jumper.png', hud.CX, hud.CY)
    jumper.x, jumper.y = hud.CX * 0.2, hud.CY * 0.15
    jumper:scale(0.2, 0.2)
    interaction:insert(jumper)

    jumperPosition = display.newImage('src/assets/jumper.png', hud.CX, hud.CY)
    jumperPosition.x, jumperPosition.y = hud.CX * 1.07, hud.CY * 0.32
    jumperPosition:scale(0.2, 0.2)
    jumperPosition.alpha = 0
    interaction:insert(jumperPosition)

    sceneGroup:insert(interaction)
    
    nextPage = display.newImageRect('src/assets/next_page.png', hud.btnNextWidth, hud.btnNextHeight)
    nextPage.x, nextPage.y = hud.btnNextX, hud.btnNextY
    sceneGroup:insert(nextPage)

    local contentText = display.newImage('src/assets/content-6.png', hud.textX, hud.textY)
    contentText:scale(0.50, 0.50)
    sceneGroup:insert(contentText)

    local tips = display.newImageRect('src/assets/tips-6.png', hud.tipsWidth, hud.tipsHeight)
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
        jumper:addEventListener('touch', handleLamp)
        jumper:addEventListener('touch', moverObjeto) 
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
        jumper:removeEventListener('touch', handleLamp)
        jumper:removeEventListener('touch', moverObjeto)
 
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