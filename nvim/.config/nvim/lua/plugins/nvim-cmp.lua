local config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- Load friendly-snippets into LuaSnip
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Make LuaSnip work with nvim-cmp
    luasnip.config.setup({})

    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },

        -- Show borders on the completion and documentation windows
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },

        mapping = cmp.mapping.preset.insert({
            -- Navigate completion list
            ["<C-j>"] = cmp.mapping.select_next_item(),
            ["<C-k>"] = cmp.mapping.select_prev_item(),

            -- Scroll docs popup
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),

            -- Manually trigger completion
            ["<C-Space>"] = cmp.mapping.complete(),

            -- Close completion
            ["<C-e>"] = cmp.mapping.abort(),

            -- Confirm selection. select=false means you must explicitly
            -- pick an item (won't auto-select the first one)
            ["<CR>"] = cmp.mapping.confirm({ select = false }),

            -- Tab: confirm if item selected, otherwise jump to next snippet placeholder
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_locally_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { "i", "s" }),

            -- Shift+Tab: go back in completion list or to previous snippet placeholder
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.locally_jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),

        -- Sources ordered by priority (highest first)
        sources = cmp.config.sources({
            { name = "nvim_lsp" },   -- LSP: go-to-def, types, methods, etc.
            { name = "luasnip" },    -- Snippets
            { name = "path" },       -- File system paths
        }, {
            { name = "buffer", keyword_length = 3 }, -- Words from current buffer (fallback)
        }),

        -- Nice icons next to each completion item showing its kind
        formatting = {
            format = function(entry, vim_item)
                local kind_icons = {
                    Text = "󰉿",  Snippet = "",   Method = "󰆧",
                    Function = "󰊕", Constructor = "", Field = "󰜢",
                    Variable = "󰀫", Class = "󰠱",  Interface = "",
                    Module = "",   Property = "󰜢", Unit = "󰑭",
                    Value = "󰎠",   Enum = "",     Keyword = "󰌋",
                    Color = "󰏘",   File = "󰈙",   Reference = "󰈇",
                    Folder = "󰉋",  EnumMember = "", Constant = "󰏿",
                    Struct = "󰙅",  Event = "",   Operator = "󰆕",
                    TypeParameter = "",
                }
                vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)
                -- Show source name in menu column
                vim_item.menu = ({
                    nvim_lsp = "[LSP]",
                    luasnip  = "[Snip]",
                    buffer   = "[Buf]",
                    path     = "[Path]",
                })[entry.source.name]
                return vim_item
            end,
        },
    })

    -- Autocomplete in command-line mode for / and ? (search)
    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
    })

    -- Autocomplete in command-line mode for : (commands)
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
            { { name = "path" } },
            { { name = "cmdline" } }
        ),
    })
end

return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",   -- only loads when you start typing (keeps startup fast)
    dependencies = {
        -- Snippet engine
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",

        -- Ready-made snippet collection (React, Python, JS, etc.)
        "rafamadriz/friendly-snippets",

        -- Completion sources
        "hrsh7th/cmp-nvim-lsp",   -- LSP completions
        "hrsh7th/cmp-buffer",     -- current buffer words
        "hrsh7th/cmp-path",       -- file paths
        "hrsh7th/cmp-cmdline",    -- command-line completions
    },
    config = config,
}
