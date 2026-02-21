My Neovim dotfiles.

These dotfiles make use of Neovim's native package manager, so Neovim 0.12 or
Neovim Nightly is needed to operate the dotfiles.

The dotfiles are written in Fennel. They are compiled to Lua using hotpot.nvim.
Note: as part of the rewrite and general cleanup, this version of the dotfiles
lacks some features that are not very high critical right now, waiting to be
added again:

1. Support for java and jdtls is temporally removed until I see what's the
   state of the art currently for programming with Java and jdt-ls. Things were
   solid, it's more about confirming that it is still the way to do things.

2. Some features of the LSP have been removed and not rewritten to
   see if the state of the art has changed over the last couple of
   years.

3. Similarly, I have not migrated my DAP config because I cannot remember when
   was the last time I used the DAP protocol for anything real. Probably one of
   those things that I setup for the aesthetics and the aura, but in the end of
   the day if I need to debug, I'll use lldb, the browser devtools or my good
   old friend console.log.

In regards to the LSP, specifically:

1. Not every keybinding has been translated. As I miss them, I will
   find the new way to do things in Neovim 0.12, and if I don't like
   it, I will add new keybindings.

2. I have removed Mason, because I am going to have a situation with
   the package managers that I need to consider, and maybe at the
   moment it is not a good idea to have another package manager
   installing things to my computers.

3. I am not turning off semantic formatting because I want to see if
   it doesn't suck anymore.

4. No fix all imports action anymore. Let's see the state
   of the art before throwing it away.

The online backup is hosted at https://git.danirod.es/dotfiles/nvim. There is a
GitHub mirror, but it is read only and only used as fallback and for clout.
