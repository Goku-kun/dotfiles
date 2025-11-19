-- ============================================================================
-- DEVCONTAINER - Development Container Integration
-- ============================================================================
-- Integrates Neovim with development containers, mounting config files
-- into the container for seamless remote development.
--
-- Repo: https://codeberg.org/esensar/nvim-dev-container
-- ============================================================================

require("devcontainer").setup {
    attach_mounts = {
        -- Mount neovim config as readonly
        neovim_config = {
            enabled = true,
            options = { "readonly" }
        },
        -- Mount neovim data directory
        neovim_data = {
            enabled = true,
        },
        -- Mount neovim state directory
        neovim_state = {
            enabled = true,
        },
    }
}
