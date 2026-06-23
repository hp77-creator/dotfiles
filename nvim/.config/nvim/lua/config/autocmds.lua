-- ============================================================
--  LSP Keymaps (set up when an LSP server attaches to a buffer)
-- ============================================================

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
    callback = function(event)
        local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        -- Navigation
        map("gd", vim.lsp.buf.definition,      "Go to definition")
        map("gD", vim.lsp.buf.declaration,     "Go to declaration")
        map("gi", vim.lsp.buf.implementation,  "Go to implementation")
        map("gr", vim.lsp.buf.references,      "Find references")
        map("gt", vim.lsp.buf.type_definition, "Go to type definition")

        -- Info
        map("K",  vim.lsp.buf.hover,           "Hover documentation")

        -- Actions
        map("<leader>rn", vim.lsp.buf.rename,       "Rename symbol")
        map("<leader>ca", vim.lsp.buf.code_action,  "Code action")

        -- Diagnostics
        map("<leader>d",  vim.diagnostic.open_float, "Show line diagnostics")
        map("[d",         vim.diagnostic.goto_prev,  "Previous diagnostic")
        map("]d",         vim.diagnostic.goto_next,  "Next diagnostic")
    end,
})
