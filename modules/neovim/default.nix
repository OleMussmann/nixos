{ pkgs, user, ... }:
{
  home-manager.users.${user} =
  {
    programs.neovim = {
      enable = true;
      extraConfig = ''
        colorscheme tokyonight-night
        set colorcolumn=80
        set ignorecase
        set scrolloff=3
        set smartcase

        let mapleader=" "

        " print invisible characters
        "set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»
        set listchars=tab:→\ ,nbsp:␣,trail:•,precedes:«,extends:»
        set list

        " numbering
        set number
        set relativenumber

        " tabs and spaces handling
        set expandtab
        set tabstop=2
        set softtabstop=2
        set shiftwidth=2

        " folding
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
        set nofoldenable
      '';
      extraPackages = with pkgs; [
        gcc
        ripgrep
        tree-sitter
      ];
      plugins = with pkgs.vimPlugins; [
        #
        #diffview-nvim                    # single tabpage interface for diffs
        {
          plugin = gitsigns-nvim;        # git decorations
          type = "lua";
          config = ''
            require('gitsigns').setup()
          '';
        }
        #hop-nvim                         # jump anywhere
        indent-blankline-nvim            # indentation guides
        {
          plugin = lualine-nvim;          # status line
          type = "lua";
          config = ''
            local function metals_status()
            return vim.g["metals_status"] or ""
            end
            require('lualine').setup(
            {
              -- options = { theme = 'dracula-nvim' },
              sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff' },
                lualine_c = { 'filename', metals_status },
                lualine_x = {'encoding', 'filetype'},
                lualine_y = {'progress'},
                lualine_z = {'location'}
              }
            }
            )
          '';
        }
        #{
        #  plugin = nvim-treesitter-pyfold;          # sane folding for python
        #  type = "lua";
        #  config = ''
        #    packadd! nvim-treesitter-pyfold
        #    require('nvim-treesitter.configs').setup(
        #    {
        #        pyfold = {
        #          enable = true,
        #          custom_foldtext = true
        #        }
        #    })
        #  '';
        #}
        # toggleterm
        #{
        #  plugin = toggleterm-nvim;
        #  type = "lua";
        #  config = ''
        #    require('toggleterm').setup()
        #  '';
        #}
        nerdcommenter                    # better commenting
        #null-ls-nvim                     # make non-lsp plugins hook into lsp
        #nvim-dap                         # debug adapter protocol, dependency for telescope-dap-nvim
        #nvim-surround                    # surround selections
        nvim-treesitter.withAllGrammars  # syntax highlighting
        nvim-treesitter-context          # show code context
        nvim-treesitter-refactor         # refactoring
        nvim-treesitter-textobjects      # syntax aware text-objects

        # completion
        {
          plugin = nvim-cmp;
          type = "lua";
          config = ''
            local cmp = require'cmp'

            cmp.setup({
              snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                  -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                  require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                  -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                  -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                end,
              },
              window = {
                -- completion = cmp.config.window.bordered(),
                -- documentation = cmp.config.window.bordered(),
              },
              mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
              }),
              sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'treesitter' },
                -- { name = 'vsnip' }, -- For vsnip users.
                { name = 'luasnip' }, -- For luasnip users.
                -- { name = 'ultisnips' }, -- For ultisnips users.
                -- { name = 'snippy' }, -- For snippy users.
              }, {
                { name = 'buffer' },
                -- { name = 'cmdline' },
                -- { name = 'cmdline-history' },
                { name = 'path' },
              })
            })

          '';
        }
        nvim-lspconfig
        cmp-nvim-lsp
        cmp-buffer
        #cmp-cmdline
        #cmp-cmdline-history
        cmp-path
        cmp-treesitter                   # use treesitter for nvim-cmp

        luasnip
        cmp_luasnip

        #plenary-nvim                     # lua functions, dependency for telescope
        #telescope-dap-nvim               # debug adapter protocol integrated in telescope
        #telescope-lsp-handlers-nvim      # ??
        #telescope-live-grep-args-nvim    # ??
        #telescope-frecency-nvim          # file priorization by frequency and recency
        #telescope-file-browser-nvim      # file browser
        #telescope-fzf-native-nvim        # fzf for telescope
        #telescope-nvim                   # fuzzy finder
        #telescope-symbols-nvim           # pick and insert symbols
        #telescope-ultisnips-nvim         # smart snippets
        tokyonight-nvim                  # theme
        vim-nix                          # syntax highlighting for nix
        #vim-fugitive                     # git integration
        #vim-repeat                       # repeat also plugin commands
      ];
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withPython3 = true;
    };

    home = {
      sessionVariables = {
        # default editor
        EDITOR = "nvim";
      };
    };
  };
}
