setl makeprg=eslint\ --format\ compact
setl errorformat+=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
setl formatprg=prettier\ --stdin-filepath\ %
