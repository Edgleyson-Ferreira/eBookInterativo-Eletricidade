local composer = require("composer")

local composer = require("composer")
local util = require('util')
local hud = require("src.hud.fixedPositions")

local physics = require("physics")

physics.start()

local scene = composer.newScene()

local nextPage
local algodao
local vidro
local carregado

local function next()
    composer.gotoScene('src.scenes.scene04', {
        effect = "fade",
        time = 500
    })
end

local function prev()
    composer.gotoScene('src.scenes.scene02', {
        effect = "fade",
        time = 500
    })
end

local function objectsAddBody()
    physics.addBody(carregado, "static", {
        isSensor = true
    })
    physics.addBody(algodao, "dynamic", {
        bounce = 0.2
    })
    algodao.gravityScale = 0
end

local function moverObjeto(event)

    local objeto = event.target
    if objeto ~= nil then
        objeto.x = event.x
        objeto.y = event.y
    end
end

local function fadeIn()
    transition.to(carregado, {
        time = 3000,
        alpha = 1
    })
end

local function onCollision(event)

    if (event.phase == "began" and event.other == carregado) then
        timer.performWithDelay(3000, fadeIn)

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
    local rail = 50

    local interaction = display.newGroup()

    vidro = display.newImageRect('src/assets/vidro.png', 100, 100)
    vidro.x, vidro.y = hud.CX * 1.5, hud.CY * 0.3
    interaction:insert(vidro)

    carregado = display.newImageRect('src/assets/carregado.png', 100, 100)
    carregado.x, carregado.y = hud.CX * 1.5, hud.CY * 0.3
    carregado.alpha = 0

    interaction:insert(carregado)

    algodao = display.newImageRect('src/assets/algodao.png', 100, 100)
    algodao.x, algodao.y = hud.CX * 0.5, hud.CY * 0.3
    interaction:insert(algodao)

    sceneGroup:insert(interaction)

    nextPage = display.newImageRect('src/assets/next_page.png', hud.btnNextWidth, hud.btnNextHeight)
    nextPage.x, nextPage.y = hud.btnNextX, hud.btnNextY
    sceneGroup:insert(nextPage)

    local contentText = display.newImage('src/assets/content-3.png', hud.textX, hud.textY)
    contentText:scale(0.50, 0.50)
    sceneGroup:insert(contentText)

    local tips = display.newImageRect('src/assets/tips-3.png', hud.tipsWidth, hud.tipsHeight)
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
        algodao:addEventListener("touch", moverObjeto)
        algodao:addEventListener("collision", onCollision)
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
        algodao:removeEventListener("touch", moverObjeto)
        algodao:removeEventListener("collision", onCollision)
        physics.removeBody(algodao)
        physics.removeBody(carregado)

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
