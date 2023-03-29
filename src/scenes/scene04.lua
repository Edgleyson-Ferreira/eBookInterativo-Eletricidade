local composer = require("composer")

local composer = require("composer")
local util = require('util')
local hud = require("src.hud.fixedPositions")

local physics = require("physics")

physics.start()

local scene = composer.newScene()

local nextPage
local eletrizado
local neutro
local semi
local semiEletrizado

local function next()
    composer.gotoScene('src.scenes.scene05', {
        effect = "fade",
        time = 500
    })
end

local function prev()
    composer.gotoScene('src.scenes.scene03', {
        effect = "fade",
        time = 500
    })
end

local function objectsAddBody()
    physics.addBody(eletrizado, "dynamic", {
        radius = rail,
        friction = 0.5,
        bounce = 0.0,
        density = 0.5,
        angularDamping = 0.5
    })

    physics.addBody(semi, "static", {
        radius = rail,
        bounce = 0.0
    })
    physics.addBody(semiEletrizado, "dynamic", {
        radius = rail,
        friction = 0.5,
        density = 1,
        bounce = 0.0,
        angularDamping = 0.5
    })

    physics.addBody(neutro, "static", {
        radius = rail,
        bounce = 0.0
    })
end


local function moverObjeto(event)

    local objeto = event.target
    objeto:setLinearVelocity(0, 0)
    objeto.isAwake = false

    if objeto ~= nil then
        objeto.x = event.x
        objeto.y = event.y
    end

end

local function fadeIn()
    transition.to(semi, {
        alpha = 1
    })
    transition.to(neutro, {
        alpha = 0
    })
    transition.to(eletrizado, {
        alpha = 0
    })
    transition.to(semiEletrizado, {
        alpha = 1
    })
end

local function removeBodies()
    physics.removeBody(eletrizado)
end

local function onCollision(event)
    if (event.phase == "began" and event.other == semi) then
        fadeIn()
        eletrizado:removeEventListener("touch", moverObjeto)
        eletrizado:removeEventListener("collision", onCollision)
        timer.performWithDelay(1, removeBodies)
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

    eletrizado = display.newImageRect('src/assets/eletrizado.png', 125, 124)
    eletrizado.x, eletrizado.y = hud.CX * 0.5, hud.CY * 0.3

    interaction:insert(eletrizado)

    semiEletrizado = display.newImageRect('src/assets/semi-eletrizado.png', 125, 124)
    semiEletrizado.x, semiEletrizado.y = hud.CX * 1.1, hud.CY * 0.4
    semiEletrizado.alpha = 0

    interaction:insert(semiEletrizado)

    semi = display.newImageRect('src/assets/semi-eletrizado.png', 125, 124)
    semi.x, semi.y = hud.CX * 1.5, hud.CY * 0.35
    semi.alpha = 0
    interaction:insert(semi)

    neutro = display.newImageRect('src/assets/neutro.png', 100, 100)
    neutro.x, neutro.y = hud.CX * 1.5, hud.CY * 0.35

    interaction:insert(neutro)

    sceneGroup:insert(interaction)

    nextPage = display.newImageRect('src/assets/next_page.png', hud.btnNextWidth, hud.btnNextHeight)
    nextPage.x, nextPage.y = hud.btnNextX, hud.btnNextY
    sceneGroup:insert(nextPage)

    local contentText = display.newImage('src/assets/content-4.png', hud.textX, hud.textY)
    contentText:scale(0.50, 0.50)
    sceneGroup:insert(contentText)

    local tips = display.newImageRect('src/assets/tips-4.png', hud.tipsWidth, hud.tipsHeight)
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
        eletrizado:addEventListener("touch", moverObjeto)
        eletrizado:addEventListener("collision", onCollision)
        semiEletrizado:addEventListener("touch", moverObjeto)
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
        eletrizado:removeEventListener("touch", moverObjeto)
        eletrizado:removeEventListener("collision", onCollision)
        semiEletrizado:removeEventListener("touch", moverObjeto)
        physics.removeBody(eletrizado)
        physics.removeBody(semiEletrizado)
        physics.removeBody(semi)
        physics.removeBody(neutro)
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
