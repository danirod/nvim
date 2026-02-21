(local options {:wrap false
                :showmatch true
                :list true
                :signcolumn :yes
                :number true
                :relativenumber true})

(each [key value (pairs options)]
  (tset vim :opt key value))
