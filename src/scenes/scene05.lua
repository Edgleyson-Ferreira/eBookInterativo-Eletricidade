local composer = require("composer")

local composer = require("composer")
local util = require('util')
local hud = require("src.hud.fixedPositions")

local physics = require("physics")

physics.start()
physics.setGravity(0, 0)

local scene = composer.newScene()

local nextPage
local vidro
local misto
local separado
local rail = 50

local function next()
    composer.gotoScene('src.scenes.scene06', {
        effect = "fade",
        time = 500
    })
end

local function prev()
    composer.gotoScene('src.scenes.scene04', {
        effect = "fade",
        time = 500
    })
end

local function objectsAddBody()
    physics.addBody(vidro, "dynamic", {
        radius = rail
    })

    physics.addBody(misto, "static", {
        radius = rail * 2
    })
end

local function moverObjeto(event)
    local objeto = event.target

    if objeto ~= nil then
        objeto.x = event.x
        objeto.y = event.y
    end
end

local function fadeIn()
    transition.to(separado, {
        alpha = 1
    })
    transition.to(misto, {
        alpha = 0
    })
end

local function onCollision(event)
    if (event.phase == "began" and event.other == misto) then
        fadeIn()
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

    vidro = display.newImageRect('src/assets/indutor-vidro.png', 124, 40)
    vidro.x, vidro.y = hud.CX * 0.5, hud.CY * 0.3
    vidro.gravityScale = 0
    interaction:insert(vidro)

    misto = display.newImageRect('src/assets/eletrizado-misto.png', 100, 100)
    misto.x, misto.y = hud.CX * 1.5, hud.CY * 0.3
    interaction:insert(misto)

    separado = display.newImageRect('src/assets/eletrizado-separado.png', 100, 100)
    separado.x, separado.y = hud.CX * 1.5, hud.CY * 0.3
    separado.alpha = 0
    interaction:insert(separado)

    sceneGroup:insert(interaction)

    nextPage = display.newImageRect('src/assets/next_page.png', hud.btnNextWidth, hud.btnNextHeight)
    nextPage.x, nextPage.y = hud.btnNextX, hud.btnNextY
    sceneGroup:insert(nextPage)

    local contentText = display.newImage('src/assets/content-5.png', hud.textX, hud.textY)
    contentText:scale(0.50, 0.50)
    sceneGroup:insert(contentText)

    local tips = display.newImageRect('src/assets/tips-5.png', hud.tipsWidth, hud.tipsHeight)
    tips.x, tips.y = hud.tipsX, hud.tipsY
    sceneGroup:insert(tips)

end

-- show()
function scene:show(event)

    local sceneGroup = self.view
    local phase = event.phase
    objectsAddBody()

    if (phase == "will") then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif (phase == "did") then
        -- Code here runs when the scene is entirely on screen
        nextPage:addEventListener('tap', next)
        vidro:addEventListener("collision", onCollision)
        vidro:addEventListener("touch", moverObjeto)

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
        nextPage:removeEventListener('tap', next)
        vidro:removeEventListener("touch", moverObjeto)
        vidro:removeEventListener("collision", onCollision)
        physics.removeBody(vidro)
        physics.removeBody(misto)
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
