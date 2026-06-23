local config = function ()
    local theme = require("lualine.themes.nightfox")
    -- theme.normal.c.bg = nil -- keep this if you want ur bg to be transparent
    require('lualine').setup {
        options = {globalstatus = true},
        tabline = {
            lualine_a = {
                'buffers'
            }
        },
        sections = {}
    }
    
end

return {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    config = config
}