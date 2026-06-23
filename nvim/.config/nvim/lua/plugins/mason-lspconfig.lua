return {
    "williamboman/mason-lspconfig.nvim",
    event = "BufReadPre",
    dependencies = {
        "williamboman/mason.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "neovim/nvim-lspconfig",  -- still needed for default server configs (cmd, filetypes, root_dir)
    },
    config = function()
        local mason_lspconfig = require("mason-lspconfig")

        mason_lspconfig.setup({
            ensure_installed = {
                "efm",
                "lua_ls",
            },
            automatic_installation = true,
        })

        -- Neovim 0.11+ native LSP API:
        -- Set cmp capabilities globally for ALL servers at once
        vim.lsp.config("*", {
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
        })

        -- Enable every server Mason has installed
        -- (lspconfig provides the default cmd/filetypes/root_dir config)
        for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
            vim.lsp.enable(server_name)
        end
    end,
}