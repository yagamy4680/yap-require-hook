#
# yap-require-hook
#
module.initialized = no
module.loaded-modules = []


# Hook to `module.js` in nodejs
#
hook = ->
  system = require \module
  {_load} = system
  system._load = (request, parent, isMain) ->
    {pre, post, loaded-modules} = module
    context = pre request, parent, isMain if pre?
    global <<< context if context?
    m = _load request, parent, isMain
    post request, m if post?
    loaded-module = module: m, name: request
    loaded-modules.push loaded-module
    return m



module.exports = exports =

  install: (pre, post) ->
    return if module.initialized
    module.pre = pre if pre?
    module.post = post if post?
    module.initialized = yes
    hook!

  get-name: (m) ->
    require! <[path]>
    {find-index} = require \prelude-ls
    {loaded-modules} = module
    name = null
    idx = loaded-modules |> find-index (.module == m)
    name = loaded-modules[idx].name if idx?
    return path.basename name

