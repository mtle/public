return {
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = {} },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      for server, server_opts in pairs(opts.servers) do
        server_opts.mason = false
      end
    end,
  },
--  {
  --    "neovim/nvim-lspconfig",
  --    opts = function(_, opts)
    --      -- Disable all LSP servers
    --      for server, server_opts in pairs(opts.servers) do
    --        server_opts.enabled = false
    --      end
    --      -- Optionally, disable auto-formatting
    --      opts.autoformat = false
    --      return opts
    --    end,
    --  },
    --  { "akinsho/bufferline.nvim", enabled = false },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    opts = function(_, opts)
      opts.enable = false
      return opts
    end,
  },
  { "folke/flash.nvim", enabled = false },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "bash", "lua", "python" }
    }
  }
}
