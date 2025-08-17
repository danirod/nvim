(local dap (require :dap))
(set dap.adapters.codelldb {:executable {:args [:--port "${port}"]
                                         :command (.. (vim.fn.stdpath :data)
                                                      :/mason/bin/codelldb)}
                            :port "${port}"
                            :type :server})

(set dap.configurations.cpp [{:cwd "${workspaceFolder}"
                              :name "Launch file"
                              :program (fn []
                                         (vim.fn.input "Path to executable: "
                                                       (.. (vim.fn.getcwd) "/")
                                                       :file))
                              :request :launch
                              :stopOnEntry false
                              :type :codelldb}])

(set dap.configurations.c dap.configurations.cpp)
(set dap.configurations.rust dap.configurations.cpp)
(set dap.adapters.go {:command (.. (vim.fn.stdpath :data)
                                   :/mason/bin/go-debug-adapter)
                      :type :executable})

(set dap.configurations.go [{:dlvToolPath (.. (vim.fn.stdpath :data)
                                              :/mason/bin/dlv)
                             :name :Debug
                             :program "${file}"
                             :request :launch
                             :showLog false
                             :type :go}])

(fn dap.adapters.python [cb config]
  (if (= config.request :attach)
      (let [port (. (or config.connect config) :port)
            host (or (. (or config.connect config) :host) :127.0.0.1)]
        (cb {: host
             :options {:source_filetype :python}
             :port (assert port
                           "`connect.port` is required for a python `attach` configuration")
             :type :server}))
      (cb {:command (.. (vim.fn.stdpath :data) :/mason/bin/debugpy-adapter)
           :options {:source_filetype :python}
           :type :executable})))

(set dap.configurations.python [{:name "Launch file"
                                 :program "${file}"
                                 :pythonPath (fn []
                                               (local cwd (vim.fn.getcwd))
                                               (if (= (vim.fn.executable (.. cwd
                                                                             :/venv/bin/python))
                                                      1)
                                                   (.. cwd :/venv/bin/python)
                                                   (= (vim.fn.executable (.. cwd
                                                                             :/.venv/bin/python))
                                                      1)
                                                   (.. cwd :/.venv/bin/python)
                                                   :/usr/bin/python))
                                 :request :launch
                                 :type :python}])

(set dap.adapters.pwa-node {:executable {:args ["${port}"]
                                         :command (.. (vim.fn.stdpath :data)
                                                      :/mason/bin/js-debug-adapter)}
                            :host :localhost
                            :port "${port}"
                            :type :server})

(set dap.configurations.javascript
     [{:cwd "${workspaceFolder}"
       :name "Launch file"
       :program "${file}"
       :request :launch
       :type :pwa-node}])

(set dap.configurations.typescript dap.configurations.javascript)
(fn dap.adapters.ruby [callback config]
  (callback {:executable {:args [:exec
                                 :rdbg
                                 :-n
                                 :--open
                                 :--port
                                 "${port}"
                                 :-c
                                 "--"
                                 :bundle
                                 :exec
                                 config.command
                                 config.script]
                          :command :bundle}
             :host :127.0.0.1
             :port "${port}"
             :type :server}))

(set dap.configurations.ruby [{:command :ruby
                               :localfs true
                               :name "debug current file"
                               :request :attach
                               :script "${file}"
                               :type :ruby}
                              {:command :rspec
                               :localfs true
                               :name "run current spec file"
                               :request :attach
                               :script "${file}"
                               :type :ruby}])

(set dap.configurations.java [{:javaExec :java
                               :mainClass (fn [] (vim.fn.input "Main class: "))
                               :name :Java
                               :request :launch
                               :type :java}
                              {:hostName :127.0.0.1
                               :name "Debug (Attach) - Remote"
                               :port 5005
                               :request :attach
                               :type :java}])

(local dapui (require :dapui))
(dapui.setup {:layouts [{:elements [{:id :scopes :size 0.25}
                                    {:id :breakpoints :size 0.25}
                                    {:id :stacks :size 0.25}
                                    {:id :watches :size 0.25}]
                         :position :right
                         :size 40}
                        {:elements [{:id :repl :size 0.5}
                                    {:id :console :size 0.5}]
                         :position :bottom
                         :size 10}]})

(fn dap.listeners.before.attach.dapui_config [] (dapui.open))
(fn dap.listeners.before.launch.dapui_config [] (dapui.open))
(fn dap.listeners.before.event_terminated.dapui_config [] (dapui.close))
(fn dap.listeners.before.event_exited.dapui_config [] (dapui.close))

(let [conditional_breakpoint (fn []
                               (let [condition (vim.fn.input "Condition: ")]
                                 (dap.toggle_breakpoint condition)))
      wk (require :which-key)]
  (wk.add [{1 :<Leader>du 2 dapui.toggle :desc "Toggle DapUI interface"}
           {1 :<Leader>db 2 dapui.toggle_breakpoint :desc "Toggle breakpoint"}
           {1 :<Leader>dc
            2 conditional_breakpoint
            :desc "Add conditional breakpoint"}
           {1 :<f5> 2 dap.continue :desc "Continue debugging"}
           {1 :<f10> 2 dap.step_over :desc "Step over"}
           {1 :<f11> 2 dap.step_into :desc "Step into"}
           {1 :<f12> 2 dap.step_out :desc "Step out"}]))
