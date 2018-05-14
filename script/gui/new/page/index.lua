local gui = require 'yue.gui'
local timer = require 'gui.timer'
local lang = require 'share.lang'

local view = gui.Container.create()

local label = gui.Label.create(lang.ui.DRAG_MAP)
label:setcolor('#222')
label:setfont(Font { size = 16 })
label:setstyle { Height = 50, Width = 200 }
view:addchildview(label)

local about = Button(lang.ui.VERSION .. (require 'share.changelog')[1].version, '#333743') 
about:setstyle { Position = 'absolute', Bottom = 20, Right = 0, Width = 140 }
function about:onclick()
    window:show_page('about')
end
view:addchildview(about)
view:setstyle { FlexGrow = 1, FlexDirection = 'row', AlignItems = 'center', JustifyContent = 'center' } 

local hover = false
local ani = nil
function view:onmouseenter()
    hover = true
    timer.wait(1000, function()
        if hover then
            local n = 2
            ani = timer.count(100, 6, function()
                n = n + 1
                label:setcolor('#' .. n .. n .. n)
            end)
        end
    end)
end
function view:onmouseleave()
    hover = false
    label:setcolor('#222')
    if ani then ani:remove() end
end

return view
