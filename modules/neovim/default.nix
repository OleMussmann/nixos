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
      '';
      extraPackages = with pkgs; [
        gcc
        ripgrep
        tree-sitter
      ];
      plugins = with pkgs.vimPlugins; [
        #cmp-treesitter                   # use treesitter for nvim-cmp
        #diffview-nvim                    # single tabpage interface for diffs
        #gitsigns-nvim                    # git decorations
        ##hop-nvim                         # jump anywhere
        indent-blankline-nvim            # indentation guides
        #lualine-nvim                     # status line
        nerdcommenter                    # better commenting
        #null-ls-nvim                     # make non-lsp plugins hook into lsp
        #nvim-dap                         # debug adapter protocol, dependency for telescope-dap-nvim
        #nvim-surround                    # surround selections
        #nvim-treesitter.withAllGrammars  # syntax highlighting
        #nvim-treesitter-context          # show code context
        #nvim-treesitter-pyfold           # smart folding
        #nvim-treesitter-refactor         # refactoring
        #nvim-treesitter-textobjects      # syntax aware text-objects
        #nvim-cmp                         # completion
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
        #toggleterm-nvim                  # quick terminal
        tokyonight-nvim                  # theme
        #ultisnips                        # smart snippets, dependency for telescope-ultisnips-nvim
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
