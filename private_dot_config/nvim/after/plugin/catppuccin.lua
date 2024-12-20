
require("catppuccin").setup({
    flavour = "macchiato",
    term_colors = true,
    transparent_background = not vim.g.neovide,
    dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.20,

    },
    integrations = {
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        which_key = true,
        mason = true,
        notify = true,
        indent_blankline = {
            enabled = true,
            scope_color = "sapphire",
            colored_indent_levels = true,
        },
        dropbar = {
            enabled = true,
            color_mode = true,
        },
        colorful_winsep = {
            enabled = true,
            color = "pink",
        },
    },
})

vim.cmd.colorscheme "catppuccin"

