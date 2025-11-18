local port = tonumber(os.getenv('GDScript_Port')) or 6005
local cmd = vim.lsp.rpc.connect('127.0.0.1', port)
local pipe

if vim.fn.has("win32") then
  pipe = "\\\\.\\pipe\\nvim-godot"
elseif vim.fn.has("macunix") then
  pipe = "/tmp/nvim-godot.pipe"
end

vim.lsp.start({
  name = 'Godot',
  cmd = cmd,
  root_dir = vim.fs.dirname(vim.fs.find({ 'project.godot', '.git' }, { upward = true })[1]),
  on_attach = function(client, bufnr)
    vim.fn.serverstart(pipe)
  end
})

