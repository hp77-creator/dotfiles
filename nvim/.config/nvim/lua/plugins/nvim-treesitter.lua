local config = function ()
    require("nvim-treesitter.configs").setup({
        indent = {
            enable = true
        },
        ensure_installed = {
            "markdown",
            "json",
            "javascript",
            "typescript",
            "yaml",
            "html",
            "css",
            "bash",
            "lua",
            "dockerfile",
            "gitignore",
            "python",
            "cpp",
            "c",
            "elixir",
            "go",
            "haskell",
            "java",
            "kotlin",
            "rust",
            "sql",
            "zig"
        },
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = true,
        }
    })
    
end

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = config
}