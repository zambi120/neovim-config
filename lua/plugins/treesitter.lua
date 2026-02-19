return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  event = 'BufRead',
  branch = 'main',
  build = ':TSUpdate',
  --main = 'nvim-treesitter.configs', -- Sets main module to use for opts
  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  ---@class TSConfig
  opts = {
    ensure_installed = {
      'lua',
      'python',
      'javascript',
      'typescript',
      'vimdoc',
      'vim',
      'regex',
      'terraform',
      'sql',
      'dockerfile',
      'toml',
      'json',
      'java',
      'groovy',
      'go',
      'gitignore',
      'graphql',
      'yaml',
      'make',
      'cmake',
      'markdown',
      'markdown_inline',
      'bash',
      'tsx',
      'css',
      'html',
      'templ',
    },
    -- Autoinstall languages that are not installed
    auto_install = false,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
  },
  config = function(_, opts)
    -- install parsers from custom opts.ensure_installed
    if opts.ensure_installed and #opts.ensure_installed > 0 then
      require('nvim-treesitter').install(opts.ensure_installed)
      -- register and start parsers for filetypes
      for _, parser in ipairs(opts.ensure_installed) do
        local filetypes = parser -- In this case, parser is the filetype/language name
        vim.treesitter.language.register(parser, filetypes)

        vim.api.nvim_create_autocmd({ 'FileType' }, {
          pattern = filetypes,
          callback = function(event)
            vim.treesitter.start(event.buf, parser)
          end,
        })
      end
    end
  end,

  -- There are additional nvim-treesitter modules that you can use to interact
  -- with nvim-treesitter. You should go explore a few and see what interests you:
  --
  --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
  --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
