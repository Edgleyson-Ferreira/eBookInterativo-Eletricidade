local _W = display.contentWidth
local _H = display.contentHeight
local _CX = display.contentCenterX
local _CY = display.contentCenterY

--CAPA
local coverX = _CX
local coverY = _CY

-- Titulo
local titleX = _CX
local titleY = _CY * 1/11

local subTitleX = _CX
local subTitleY = _CY * 0.2

-- BOTÃO PRÓXIMA PÁGINA
local btnNextWidth = _W * 0.1
local btnNextHeight = _H * 0.1

local btnNextX = _W * 0.9
local btnNextY = _H * 0.9

-- BOTÃO VOLTAR PÁGINA
local btnPrevWidth = _W * 0.1
local btnPrevHeight = _H * 0.1

local btnPrevX = _W * 0.1
local btnPrevY = _H * 0.9

-- CONTEÚDO TEXTO
local textX = _W * 0.5
local textY = _H * 0.6

-- DICAS
local tipsWidth = 744
local tipsHeight = 88

local tipsX = _CX
local tipsY = _CY * 0.6

return {
    coverY = coverY,
    coverX = coverX,
    titleX = titleX,
    titleY = titleY,
    subTitleX = subTitleX,
    subTitleY = subTitleY,
    btnNextWidth = btnNextWidth,
    btnNextHeight = btnNextHeight,
    btnNextX = btnNextX,
    btnNextY = btnNextY,
    btnPrevWidth = btnPrevWidth,
    btnPrevHeight = btnPrevHeight,
    btnPrevX = btnPrevX,
    btnPrevY = btnPrevY,
    textX = textX,
    textY = textY,
    tipsX = tipsX,
    tipsY = tipsY,
    tipsHeight = tipsHeight,
    tipsWidth = tipsWidth,
    H = _H,
    W = _W,
    CX = _CX,
    CY = _CY
}
