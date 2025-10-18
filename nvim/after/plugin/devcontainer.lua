require("devcontainer").setup {
    attach_mounts = {
        neovim_config = {
            enabled = true,
            options = { "readonly" }
        },
        neovim_data = {
            enabled = true,
        },
        neovim_state = {
            enabled = true,
        },
    }
}
