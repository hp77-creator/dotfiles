local keymap = vim.keymap

local opts = {noremap=true, silent=true}

-- Directory navigation
keymap.set("n", "<leader>m", ":NvimTreeFocus<CR>", opts)
keymap.set("n", "<leader>f", ":NvimTreeToggle<CR>", opts)


-- Pane navigation
keymap.set("n", "<C-h", "<C-w>h", opts)   -- Navigate left
keymap.set("n", "<C-l", "<C-w>l", opts)   -- Navigate right
keymap.set("n", "<C-j", "<C-w>j", opts)   -- Navigate down
keymap.set("n", "<C-k", "<C-w>k", opts)   -- Navigate top


-- Window management
keymap.set("n", "<leader>sv", ":vsplit<CR>", opts)  -- Split vertically
keymap.set("n", "<leader>sh", ":hsplit<CR>", opts)  -- Split horizontally
keymap.set("n", "<leader>sm", ";MaximizerToggle<CR>", opts)  -- Toggle Minimize

-- Indenting
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")


-- Comments
-- vim.api.nvim.set_keymap("n", "<C-_>", "gcc", {noremap=false})  -- Control forward slash
-- vim.api.nvim.set_keymap("v", "<C-_>", "gcc", {noremap=false})


-- Terminal
keymap.set("n", "<leader>th", ":split | term<CR>", opts)   -- Terminal in horizontal split
keymap.set("n", "<leader>tv", ":vsplit | term<CR>", opts)  -- Terminal in vertical split
keymap.set("t", "<Esc>", "<C-\\><C-n>", opts)              -- Esc to exit terminal mode