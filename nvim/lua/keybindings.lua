local map = vim.keymap.set

map('n', "<C-p>", function ()
  require("telescope.builtin").find_files()
end)

map("n", "<C-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer tab" })
map("n", "<C-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer tab"})
map("n", "<C-n>", "<cmd>NvimTreeToggle<cr>", {desc = "Open file tree"})
map("n", "<C-d>", "<cmd>bdelete<cr>", {desc = "Delete current buffer"})
map({"n", "i", "v"}, "<C-t>", "<cmd>ToggleTerm<cr>", {desc = "Open terminal"})

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
