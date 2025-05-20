local vim = vim
local M = {}

local g_paths = {}

function M.setup(paths)
  g_paths = paths

  for _, rel_path in ipairs(paths) do
    local path = os.getenv('HOME') .. '/.local/share/nvim/arc-plug/' .. rel_path
    if vim.uv.fs_stat(path) then
      vim.opt.rtp:append(path)
    end
  end

  vim.api.nvim_create_user_command('ArcPlugInstall', M.update, {})
end

function M.update()
  local plugin_root = os.getenv('HOME') .. '/.local/share/nvim/arc-plug'
  local arc_root = plugin_root .. '/.arc'
  local obj = 0

  if vim.uv.fs_stat(arc_root) then
    obj = vim.system({'rm', '-rf', arc_root}):wait()
    if obj.code ~= 0 then
      error('rm -rf failed: ' .. obj.code .. ': ' .. obj.stderr)
    end
  end

  vim.fn.mkdir(arc_root, "p")

  obj = vim.system({'arc', 'init', '--bare'}, {cwd = arc_root}):wait()
  if obj.code ~= 0 then
    error('rm -rf failed: ' .. obj.code .. ': ' .. obj.stderr)
  end

  local total = 0
  local errors = 0
  for _, rel_path in ipairs(g_paths) do
    total = total + 1
    obj = vim.system({'rm', '-rf', plugin_root .. '/' .. rel_path}):wait()
    if obj.code ~= 0 then
      error('rm -rf failed: ' .. obj.code .. ': ' .. obj.stderr)
    end

    obj = vim.system({'arc', 'export', '--to', plugin_root, 'trunk', rel_path}, {cwd = arc_root}):wait()
    if obj.code ~= 0 then
      error('arc export failed: ' .. obj.code .. ': ' .. obj.stderr)
      errors = errors + 1
    end
  end

  obj = vim.system({'rm', '-rf', arc_root}):wait()
  if obj.code ~= 0 then
    error('rm -rf failed: ' .. obj.code .. ': ' .. obj.stderr)
  end

  vim.notify({{total .. ' arc plugins updated, ' .. errors .. ' errors'}}, true, {})
end

return M

