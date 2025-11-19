-- ============================================================================
-- UNDOTREE - Visual Undo History
-- ============================================================================
-- UndoTree visualizes the undo history and makes it easy to browse and switch
-- between different undo branches.
--
-- Repo: https://github.com/mbbill/undotree
-- ============================================================================

vim.keymap.set("n", "U", vim.cmd.UndotreeToggle, {
    desc = "Toggle UndoTree"
})
