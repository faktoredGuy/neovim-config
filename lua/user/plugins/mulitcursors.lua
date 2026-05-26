return {
    "brenton-leighton/multiple-cursors.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {},
    keys = {
        
        { "<C-d>", "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", mode = { "n", "x" }, desc = "Add next match" },

        { "<C-s>", "<Cmd>MultipleCursorsAddMatches<CR>", mode = { "n", "x" }, desc = "Add all matches" },

        { "<C-g>", "<Cmd>MultipleCursorsSkipNextMatch<CR>", mode = { "n", "x" }, desc = "Skip match" },

        { "<C-k>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "i", "x" }, desc = "Add cursor up (alternate)" },
        { "<C-j>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "i", "x" }, desc = "Add cursor down (alternate)" },
    },
}
