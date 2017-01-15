ctrlp-leader-guide
==============

🍎 Vim leader guide with ctrlp insterface.

Vim plugin for showing and executing all your `<Leader>` mappings in a readable table including the descriptions.

Installation
------------

Use your faviorte method install this plugin.

Features
--------

* List `<Leader>` mappings defined by the user and the plugins
* By default only mappings defined in `.vimrc` are listed. It honours `$MYVIMRC` variable
* Mappings from all scripts sourced by Vim can be listed if specified by configuration (see Options)
* If the line previous to the mapping is a comment it will be used as the description
* If no comment is available the **rhs** of the mapping is used as description
* Mappings are shown in a table, grouped by **source**, with the following columns
  * Mode: which mode the mapping applies to
  * LHS: left hand side of the mapping (without `<Leader>`)
  * Description: The mapping comment if present. The **rhs** otherwise

Screenshots
-----------

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
