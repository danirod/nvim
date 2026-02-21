(import-macros {: uses-pack!} :deezmacros)

(uses-pack! "https://github.com/sphamba/smear-cursor.nvim")

(let [smear-cursor (require :smear_cursor)]
  (smear-cursor.setup))
