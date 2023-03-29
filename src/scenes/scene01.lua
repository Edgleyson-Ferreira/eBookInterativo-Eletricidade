local composer = require("composer")
local util = require('util')
local hud = require("src.hud.fixedPositions")

local scene = composer.newScene()

local physics = require("physics")
physics.start()

local nextPage
local esfera1
local esfera2
local paredeEsquerda
local paredeDireita
local paredeSuperior
local paredeInferior
local myTimer

local function next()
    composer.gotoScene('src.scenes.scene02', {
        effect = "fade",
        time = 500
    })
end

local function prev()
    composer.gotoScene('src.scenes.backCover', {
        effect = "fade",
        time = 500
    })
end

local function objectsAddBody()
    physics.addBody(esfera1, "dynamic", {
        radius = 50,
        bounce = 0.0
    })
    physics.addBody(esfera2, "dynamic", {
        radius = 50,
        bounce = 0.0
    })
end

local function atrairEsferas()

    local deltaX = esfera2.x - esfera1.x
    local deltaY = esfera2.y - esfera1.y
    local distancia = math.sqrt(deltaX ^ 2 + deltaY ^ 2)

    if distancia < 350 then
        local forca = (100 - distancia) * 0.01
        local angulo = math.atan2(deltaY, deltaX)
        local forcaX = forca * math.cos(angulo)
        local forcaY = forca * math.sin(angulo)
        objectsAddBody()
        if (esfera1.polaridade == esfera2.polaridade) then
            esfera1:applyForce(forcaX, forcaY, esfera1.x, esfera1.y)
            esfera2:applyForce(-forcaX, -forcaY, esfera2.x, esfera2.y)
        else
            esfera1:applyForce(-forcaX, -forcaY, esfera1.x, esfera1.y)
            esfera2:applyForce(forcaX, forcaY, esfera2.x, esfera2.y)
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

-- create()
function scene:create(event)

    local color = util.color
    display.setDefault("background", color(9), color(0), color(35))

    local sceneGroup = self.view
    local rail = 50

    local interaction = display.newGroup()

    esfera1 = display.newImageRect('src/assets/carga_positiva.png', 100, 100)
    esfera1.x, esfera1.y = hud.CX * 0.5, hud.CY * 0.3
    esfera1.polaridade = 1
    interaction:insert(esfera1)

    esfera2 = display.newImageRect('src/assets/carga_negativa.png', 100, 100)
    esfera2.x, esfera2.y = hud.CX * 1.5, hud.CY * 0.3
    esfera2.polaridade = 2
    interaction:insert(esfera2)

    sceneGroup:insert(interaction)

    nextPage = display.newImageRect('src/assets/next_page.png', hud.btnNextWidth, hud.btnNextHeight)
    nextPage.x, nextPage.y = hud.btnNextX, hud.btnNextY
    sceneGroup:insert(nextPage)

    local contentText = display.newImage('src/assets/content-1.png', hud.textX, hud.textY)
    contentText:scale(0.50, 0.50)
    sceneGroup:insert(contentText)

    local tips = display.newImageRect('src/assets/tips-1.png', hud.tipsWidth, hud.tipsHeight)
    tips.x, tips.y = hud.tipsX, hud.tipsY
    sceneGroup:insert(tips)

    local paredeEsquerda = display.newRect(0, display.contentHeight / 2, 1, display.contentHeight)
    physics.addBody(paredeEsquerda, "static", {
        friction = 1.0,
        bounce = 0.0
    })
    paredeEsquerda:setFillColor(0, 0, 0, 0)
    paredeEsquerda.strokeWidth = 0
    sceneGroup:insert(paredeEsquerda)

    local paredeDireita = display.newRect(display.contentWidth, display.contentHeight / 2, 1, display.contentHeight)
    physics.addBody(paredeDireita, "static", {
        friction = 1.0,
        bounce = 0.0
    })
    paredeDireita:setFillColor(0, 0, 0, 0)
    paredeDireita.strokeWidth = 0
    sceneGroup:insert(paredeDireita)

    local paredeSuperior = display.newRect(display.contentWidth / 2, 0, display.contentWidth, 1)
    physics.addBody(paredeSuperior, "static", {
        friction = 1.0,
        bounce = 0.0
    })
    paredeSuperior:setFillColor(0, 0, 0, 0)
    paredeSuperior.strokeWidth = 0
    sceneGroup:insert(paredeSuperior)

    local paredeInferior = display.newRect(hud.tipsX, hud.tipsY * 0.75, display.contentWidth, 1)
    physics.addBody(paredeInferior, "static", {
        friction = 1.0,
        bounce = 0.0
    })
    paredeInferior:setFillColor(0, 0, 0, 0)
    paredeInferior.strokeWidth = 0
    sceneGroup:insert(paredeInferior)

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
        esfera1:addEventListener("touch", moverObjeto)
        Runtime:addEventListener("enterFrame", atrairEsferas)
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
        esfera1:removeEventListener("touch", moverObjeto)
        Runtime:removeEventListener("enterFrame", atrairEsferas)
        physics.removeBody(esfera1)
        physics.removeBody(esfera2)

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
scene:addEventListener("willEnterScene", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene
