return {
    {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'L3MON4D3/LuaSnip'},

    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig.nvim'},
    {
        'mrded/nvim-lsp-notify',
        dependencies = { 'rcarriga/nvim-notify' },
    }
}
