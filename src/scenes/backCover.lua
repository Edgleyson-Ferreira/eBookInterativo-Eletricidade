local composer = require("composer")
local util = require('util')
local scene = composer.newScene()
local hud = require("src.hud.fixedPositions")

local nextPage
local prevPage

local function next()
    composer.gotoScene('src.scenes.scene01', {
        effect = "fade",
        time = 500
    })
end

local function prev()
    composer.gotoScene('src.scenes.cover', {
        effect = "fade",
        time = 500
    })
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
    local color = util.color
    display.setDefault("background", color(6), color(6), color(12))

    local sceneGroup = self.view

    local bg = display.newImage(sceneGroup, 'src/assets/staticshocker-bg.png', hud.coverX, hud.coverY + 150)
    bg.fill.effect = "filter.grayscale"

    local overlay = display.newRect(sceneGroup, bg.x, bg.y, bg.width, bg.height)
    overlay:setFillColor(0, 0, 0, 0.7)

    local title = display.newText(sceneGroup, "Livro Eletrônico Interativo", hud.titleX, hud.titleY, native.systemFont,
        50)
    sceneGroup:insert(title)

    local subTitle = display.newText(sceneGroup, "Eletricidade", hud.subTitleX, hud.subTitleY, native.systemFont, 50)
    sceneGroup:insert(subTitle)

    local year = display.newText(sceneGroup, "2022.2", hud.subTitleX, hud.subTitleY + 50, native.systemFont, 24)
    sceneGroup:insert(year)

    local author = display.newText(sceneGroup, "Autor: Edgleyson Ferreira", hud.subTitleX, hud.subTitleY + 100,
        native.systemFont, 24)
    sceneGroup:insert(author)

    local advisor = display.newText(sceneGroup, "Orientador: Ewerton Mendonça", hud.subTitleX, hud.subTitleY + 125,
        native.systemFont, 24)
    sceneGroup:insert(advisor)

    local discipline = display.newText(sceneGroup, "Disciplina: Computação Gráfica e Sistemas Multimídias",
        hud.subTitleX, hud.subTitleY + 150, native.systemFont, 24)
    sceneGroup:insert(discipline)

    nextPage = display.newImageRect('src/assets/next_page.png', hud.btnNextWidth, hud.btnNextHeight)
    nextPage.x, nextPage.y = hud.btnNextX, hud.btnNextY
    sceneGroup:insert(nextPage)

    prevPage = display.newImageRect('src/assets/back_page.png', hud.btnPrevWidth, hud.btnPrevHeight)
    prevPage.x, prevPage.y = hud.btnPrevX, hud.btnPrevY
    sceneGroup:insert(prevPage)
end

-- show()
function scene:show(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif (phase == "did") then
        composer.removeScene('main')
        nextPage:addEventListener('tap', next)
        prevPage:addEventListener('tap', prev)
        -- Code here runs when the scene is entirely on screen

    end
end

-- hide()
function scene:hide(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif (phase == "did") then
        nextPage:removeEventListener('tap', next)
        prevPage:removeEventListener('tap', prev)
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
