local composer = require("composer")

local composer = require("composer")
local util = require('util')
local hud = require("src.hud.fixedPositions")

local physics = require("physics")

local scene = composer.newScene()

local nextPage
local esfera3
local esfera4
local paredeEsquerda
local paredeDireita
local paredeSuperior
local paredeInferior
local myTimer

local function next()
    composer.gotoScene('src.scenes.scene03', {
        effect = "fade",
        time = 500
    })
end

local function prev()
    composer.gotoScene('src.scenes.scene01', {
        effect = "fade",
        time = 500
    })
end

local function objectsAddBody()
    physics.addBody(esfera3, "dynamic", {
        radius = rail,
        bounce = 0.0,
        density = 0.5

    })
    physics.addBody(esfera4, "dynamic", {
        radius = rail,
        bounce = 0.0
    })
end

local function repelirEsferas()

    local deltaX = esfera3.x - esfera4.x
    local deltaY = esfera3.y - esfera4.y
    local distancia = math.sqrt(deltaX ^ 2 + deltaY ^ 2)

    if distancia < 350 then

        local forca = (distancia - 350) * 0.01
        local angulo = math.atan2(deltaY, deltaX) + math.pi
        local forcaX = forca * math.cos(angulo)
        local forcaY = forca * math.sin(angulo)
        objectsAddBody()
        if (esfera3.polaridade == esfera4.polaridade) then
            esfera3:applyForce(forcaX, forcaY, esfera3.x, esfera3.y)
            esfera4:applyForce(-forcaX, -forcaY, esfera4.x, esfera4.y)
        else
            esfera3:applyForce(-forcaX, -forcaY, esfera3.x, esfera3.y)
            esfera4:applyForce(forcaX, forcaY, esfera4.x, esfera4.y)
        end
    end
end

local function moverObjeto(event)
    local objeto = event.target

    if (event.phase == "began") then
        display.getCurrentStage():setFocus(objeto)
        objeto.isFocus = true
    end
    if objeto.isFocus then
        if (event.phase == "moved") then
            if objeto ~= nil then
                objeto.x = event.x
                objeto.y = event.y
            end
        elseif (event.phase == "ended" or event.phase == "cancelled") then
            display.getCurrentStage():setFocus(nil)
            objeto.isFocus = false
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
    local rail = 50

    physics.start()

    local interaction = display.newGroup()

    esfera3 = display.newImageRect('src/assets/carga_positiva.png', 100, 100)
    esfera3.x, esfera3.y = hud.CX * 0.5, hud.CY * 0.3
    esfera3.polaridade = 1
    esfera3.isSensor = true
    interaction:insert(esfera3)

    esfera4 = display.newImageRect('src/assets/carga_positiva.png', 100, 100)
    esfera4.x, esfera4.y = hud.CX * 1.5, hud.CY * 0.3
    esfera4.polaridade = 1
    interaction:insert(esfera4)

    sceneGroup:insert(interaction)

    nextPage = display.newImageRect('src/assets/next_page.png', hud.btnNextWidth, hud.btnNextHeight)
    nextPage.x, nextPage.y = hud.btnNextX, hud.btnNextY
    sceneGroup:insert(nextPage)

    paredeEsquerda = display.newRect(0, display.contentHeight / 2, 1, display.contentHeight)
    physics.addBody(paredeEsquerda, "static", {
        friction = 1.0,
        bounce = 0.0
    })
    paredeEsquerda:setFillColor(0, 0, 0, 0)
    paredeEsquerda.strokeWidth = 0
    sceneGroup:insert(paredeEsquerda)

    paredeDireita = display.newRect(display.contentWidth, display.contentHeight / 2, 1, display.contentHeight)
    physics.addBody(paredeDireita, "static", {
        friction = 1.0,
        bounce = 0.0
    })
    paredeDireita:setFillColor(0, 0, 0, 0)
    paredeDireita.strokeWidth = 0
    sceneGroup:insert(paredeDireita)

    paredeSuperior = display.newRect(display.contentWidth / 2, 0, display.contentWidth, 1)
    physics.addBody(paredeSuperior, "static", {
        friction = 1.0,
        bounce = 0.0
    })
    paredeSuperior:setFillColor(0, 0, 0, 0)
    paredeSuperior.strokeWidth = 0
    sceneGroup:insert(paredeSuperior)

    paredeInferior = display.newRect(hud.tipsX, hud.tipsY * 0.75, display.contentWidth, 1)
    physics.addBody(paredeInferior, "static", {
        friction = 1.0,
        bounce = 0.0
    })
    paredeInferior:setFillColor(0, 0, 0, 0)
    paredeInferior.strokeWidth = 0
    sceneGroup:insert(paredeInferior)

    local contentText = display.newImage('src/assets/content-2.png', hud.textX, hud.textY)
    contentText:scale(0.50, 0.50)
    sceneGroup:insert(contentText)

    local tips = display.newImageRect('src/assets/tips-2.png', hud.tipsWidth, hud.tipsHeight)
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
        esfera3:addEventListener("touch", moverObjeto)
        Runtime:addEventListener("enterFrame", repelirEsferas)
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
        esfera3:removeEventListener("touch", moverObjeto)
        Runtime:removeEventListener("enterFrame", repelirEsferas)
        physics.removeBody(esfera3)
        physics.removeBody(esfera4)

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
