ctrlp-leader-guide
==============

🍎 Vim leader guide with ctrlp insterface.

Vim plugin for showing all your `<Leader>` mappings with ctrlp insterface.

Installation
------------

Use your faviorte method install this plugin, such as: 

- [junegunn/vim-plug](https://github.com/junegunn/vim-plug)
- [Shougo/dein.nvim](https://github.com/Shougo/dein.vim)

Features
--------

* List `<Leader>` mappings defined by the user and the plugins
* By default only mappings defined in `.vimrc` are listed. It honours `$MYVIMRC` variable
* Mappings from all scripts sourced by Vim can be listed if specified by configuration (see Options)
* If the line previous to the mapping is a comment it will be used as the description
* If no comment is available the **rhs** of the mapping is used as description

Screenshots
-----------

![screenshot](https://cloud.githubusercontent.com/assets/4246425/21986374/1fd26d88-dc3a-11e6-8de7-384c4cddc5c1.png)

Shortcuts
---------

* `<Leader>?`and`<leader>hk`: Default mapping for triggering the plugin.

you can remap it by:

```vim
nmap <yourkey> <Plug>(FollowMyLead)
```

Options
-------
* `g:fml_all_sources`: if `1` all sources are used, if `0` just `$MYVIMRC` is used. Default `0`
* _More options coming soon_

Credit
-------

[vim-follow-my-lead](https://github.com/ktonga/vim-follow-my-lead)
