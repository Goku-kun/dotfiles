-- ============================================================================
-- GIT-WORKTREE - Seamless Worktree Management
-- ============================================================================
-- Manage git worktrees without leaving Neovim.
-- Supports creating, switching, and deleting worktrees with full session reset.
--
-- Repo: https://github.com/polarmutex/git-worktree.nvim
--
-- Usage:
-- - <leader>gwl: List and switch worktrees (Telescope)
-- - <leader>gwc: Create worktree from existing branch (fetches first)
-- - <leader>gwn: Create worktree with new branch
--
-- Inside Telescope picker:
-- - <CR>   : Switch to worktree
-- - <M-d>  : Delete worktree (Alt+D)
-- - <C-f>  : Toggle force deletion mode, then <M-d> to force delete
-- - <M-c>  : Create new worktree (Alt+C)
-- ============================================================================

local telescope = require("telescope")
local Hooks = require("git-worktree.hooks")

-- ============================================================================
-- TELESCOPE EXTENSION
-- ============================================================================

telescope.load_extension("git_worktree")

-- ============================================================================
-- HOOKS
-- ============================================================================

-- ============================================================================
-- FILES TO COPY TO NEW WORKTREES
-- ============================================================================
-- Add files/directories here that should be copied to every new worktree
-- Paths are relative to the git root

local files_to_copy = {
    ".env",
    ".env.local",
    ".claude",           -- Claude Code settings
    ".cursorrules",      -- Cursor rules if you use it
    -- Add more files as needed:
    -- ".env.development.local",
    -- "config/local.json",
}

-- Source worktree name to copy files from
local source_worktree_name = "main"

-- Create hook: Copy untracked files to new worktrees
Hooks.register(Hooks.type.CREATE, function(path, _, _)
    -- Find source worktree
    local source_path = nil
    local worktrees = vim.fn.systemlist("git worktree list --porcelain")
    for _, line in ipairs(worktrees) do
        if line:match("^worktree ") then
            local wt_path = line:gsub("^worktree ", "")
            if wt_path:match("/" .. vim.pesc(source_worktree_name) .. "$") then
                source_path = wt_path
                break
            end
        end
    end

    if not source_path then
        vim.notify("Source worktree '" .. source_worktree_name .. "' not found", vim.log.levels.WARN)
        return
    end

    -- Resolve destination path
    local dest_path
    if path:sub(1, 1) == "/" then
        dest_path = path
    else
        local parent = vim.fn.fnamemodify(source_path, ":h")
        dest_path = parent .. "/" .. path
    end

    -- Wait for worktree to be created, then copy files
    vim.defer_fn(function()
        local copied = {}
        for _, file in ipairs(files_to_copy) do
            local src = source_path .. "/" .. file
            local dst = dest_path .. "/" .. file

            if vim.fn.filereadable(src) == 1 then
                vim.fn.mkdir(vim.fn.fnamemodify(dst, ":h"), "p")
                os.execute(string.format("cp '%s' '%s'", src, dst))
                table.insert(copied, file)
            elseif vim.fn.isdirectory(src) == 1 then
                os.execute(string.format("cp -r '%s' '%s'", src, dst))
                table.insert(copied, file .. "/")
            end
        end

        if #copied > 0 then
            vim.notify("Copied: " .. table.concat(copied, ", "), vim.log.levels.INFO)
        end
    end, 500)
end)

-- Helper: Convert worktree path to absolute (handles relative paths correctly)
local function to_absolute_path(wt_path)
    -- If already absolute, return as-is
    if wt_path:sub(1, 1) == "/" then
        return wt_path
    end
    -- Look up in git worktree list for the actual absolute path
    local worktrees = vim.fn.systemlist("git worktree list --porcelain")
    for _, line in ipairs(worktrees) do
        if line:match("^worktree ") then
            local abs = line:gsub("^worktree ", "")
            -- Check if this worktree ends with our relative path
            if abs:match("/" .. vim.pesc(wt_path) .. "$") or abs == wt_path then
                return abs
            end
        end
    end
    -- Fallback: resolve relative to parent of current git root
    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
    if git_root and git_root ~= "" then
        local parent = vim.fn.fnamemodify(git_root, ":h")
        return parent .. "/" .. wt_path
    end
    return vim.fn.fnamemodify(wt_path, ":p")
end

-- Switch hook: Full session reset when changing worktrees
Hooks.register(Hooks.type.SWITCH, function(path, prev_path)
    -- Convert to absolute path BEFORE closing buffers (path might be relative)
    local abs_path = to_absolute_path(path)
    local abs_prev_path = to_absolute_path(prev_path)

    -- 1. Close all buffers (clean slate)
    vim.cmd("silent! bufdo bdelete")

    -- 2. Clear harpoon marks (project-specific, don't carry over)
    local harpoon_ok, harpoon_mark = pcall(require, "harpoon.mark")
    if harpoon_ok then
        harpoon_mark.clear_all()
    end

    -- 3. Change to the new worktree directory
    vim.cmd("cd " .. abs_path)

    -- 4. Restart LSP (pick up new project context)
    vim.cmd("LspRestart")

    -- 5. Notify with paths
    vim.notify("Switched: " .. abs_prev_path .. " -> " .. abs_path, vim.log.levels.INFO)
end)

-- Delete hook: Notify on worktree deletion
Hooks.register(Hooks.type.DELETE, function(path)
    vim.notify("Deleted worktree: " .. path, vim.log.levels.INFO)
end)

-- ============================================================================
-- KEYBINDINGS
-- ============================================================================

-- List and switch worktrees
vim.keymap.set("n", "<leader>gwl", function()
    telescope.extensions.git_worktree.git_worktree()
end, { desc = "[g]it [w]orktree [l]ist" })

-- Create worktree from existing branch (fetches first to see remote branches)
vim.keymap.set("n", "<leader>gwc", function()
    vim.notify("Fetching from origin...", vim.log.levels.INFO)
    vim.fn.system("git fetch --all --prune")
    telescope.extensions.git_worktree.create_git_worktree()
end, { desc = "[g]it [w]orktree [c]reate from branch" })

-- Create worktree with new branch
vim.keymap.set("n", "<leader>gwn", function()
    local branch_name = vim.fn.input("New branch name: ")
    if branch_name == "" then
        vim.notify("Cancelled: No branch name provided", vim.log.levels.WARN)
        return
    end

    -- Sanitize branch name for path: replace / with -
    local default_path = branch_name:gsub("/", "-")

    local worktree_path = vim.fn.input("Worktree path (default: " .. default_path .. "): ")
    if worktree_path == "" then
        worktree_path = default_path
    end

    require("git-worktree").create_worktree(worktree_path, branch_name, "origin")
    vim.notify("Creating worktree: " .. worktree_path .. " with new branch: " .. branch_name, vim.log.levels.INFO)
end, { desc = "[g]it [w]orktree [n]ew branch" })
