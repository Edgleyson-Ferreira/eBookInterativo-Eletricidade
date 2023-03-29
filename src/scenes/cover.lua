local composer = require("composer")
local util = require('util')
local scene = composer.newScene()
local hud = require("src.hud.fixedPositions")

local nextPage

local function next()
    composer.gotoScene('src.scenes.backCover', {
        effect = "fade",
        time = 500
    })
end

-- create()
function scene:create(event)
    local color = util.color
    display.setDefault("background", color(6), color(6), color(12))

    local sceneGroup = self.view

    local bg = display.newImage(sceneGroup, 'src/assets/staticshocker-bg.png', hud.coverX, hud.coverY + 150)

    local title = display.newText(sceneGroup, "Livro Eletrônico Interativo", hud.titleX, hud.titleY, native.systemFont,
        50)
    sceneGroup:insert(title)

    local subTitle = display.newText(sceneGroup, "Eletricidade", hud.subTitleX, hud.subTitleY, native.systemFont, 50)
    sceneGroup:insert(subTitle)

    local author = display.newText(sceneGroup, "2022.2", hud.subTitleX, hud.subTitleY + 50, native.systemFont, 24)
    sceneGroup:insert(author)



    nextPage = display.newImageRect('src/assets/next_page.png', hud.btnNextWidth, hud.btnNextHeight)
    nextPage.x, nextPage.y = hud.btnNextX, hud.btnNextY
    sceneGroup:insert(nextPage)
end

-- show()
function scene:show(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif (phase == "did") then
        -- Code here runs when the scene is entirely on screen
        composer.removeScene('main')
        nextPage:addEventListener('tap', next)

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

    nextPage:removeEventListener('tap', next)
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
