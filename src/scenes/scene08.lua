local composer = require("composer")

local composer = require("composer")
local util = require('util')
local hud = require("src.hud.fixedPositions")

local physics = require("physics")

physics.start()

local scene = composer.newScene()

local transform1
local transform2
local transform3
local isBroken = false
local startTime

local function next()
    composer.gotoScene('src.scenes.cover', {
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

local function myTouch(event)
    local objeto = event.target

    if event.phase == "began" then
        objeto.isFocus = true
        if isBroken == false then
            transition.to(transform1, {
                alpha = 0.01,
                time = 500
            })
            transition.to(transform2, {
                alpha = 1,
                time = 500
            })
            transition.to(transform3, {
                alpha = 0,
                time = 500
            })
            system.vibrate(500)
        elseif isBroken == true then
            transition.to(transform3, {
                alpha = 0,
                time = 500
            })
            transition.to(transform2, {
                alpha = 1,
                time = 500
            })
            system.vibrate(1500)
        end
    end
    if objeto.isFocus then
        if (event.phase == "ended" or event.phase == "cancelled") then
            objeto.isFocus = false
            if isBroken == false then
                transition.to(transform2, {
                    alpha = 0,
                    time = 500
                })
                transition.to(transform3, {
                    alpha = 1,
                    time = 500
                })
                transition.to(transform1, {
                    alpha = 0.01,
                    time = 500
                })
                isBroken = true
                system.vibrate(1500)
            elseif isBroken == true then
                transition.to(transform2, {
                    alpha = 0,
                    time = 500
                })
                transition.to(transform1, {
                    alpha = 1,
                    time = 500
                })
                transition.to(transform3, {
                    alpha = 0,
                    time = 500
                })
                system.vibrate(1500)
                isBroken = false
            end
        end
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)

    local color = util.color
    display.setDefault("background", color(9), color(0), color(35))

    local sceneGroup = self.view
    local interaction = display.newGroup()

    transform1 = display.newImage('src/assets/transform-1.png', hud.CX, hud.CY)
    transform1.x, transform1.y = hud.CX, hud.CY * 0.25
    transform1:scale(0.19, 0.19)
    transform1.nome = 'transform-1.png'
    transform1.alpha = 1
    interaction:insert(transform1)

    transform2 = display.newImage('src/assets/transform-2.png', hud.CX, hud.CY)
    transform2.x, transform2.y = hud.CX, hud.CY * 0.25
    transform2:scale(0.19, 0.19)
    transform2.nome = 'transform-2.png'
    transform2.alpha = 0
    interaction:insert(transform2)

    transform3 = display.newImage('src/assets/transform-3.png', hud.CX, hud.CY)
    transform3.x, transform3.y = hud.CX, hud.CY * 0.25
    transform3:scale(0.19, 0.19)
    transform3.nome = 'transform-3.png'
    transform3.alpha = 0
    interaction:insert(transform3)

    sceneGroup:insert(interaction)

    local contentText = display.newImage('src/assets/content-8.png', hud.textX, hud.textY)
    contentText:scale(0.50, 0.50)
    sceneGroup:insert(contentText)

    local tips = display.newImageRect('src/assets/tips-8.png', hud.tipsWidth, hud.tipsHeight)
    tips.x, tips.y = hud.tipsX, hud.tipsY
    sceneGroup:insert(tips)

    local title = display.newText("FIM",  hud.CX, hud.CY, native.systemFont, 60)
	title.x, title.y = hud.CX, hud.btnNextY
	sceneGroup:insert( title )

end

-- show()
function scene:show(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif (phase == "did") then
        -- Code here runs when the scene is entirely on screen
        transform1.touch = myTouch
        transform1:addEventListener("touch", myTouch)

    end
end

-- hide()
function scene:hide(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif (phase == "did") then
        -- Code here runs immediately after the scene goes entirely off screen
    end
end

-- destroy()
function scene:destroy(event)

    local sceneGroup = self.view
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene
