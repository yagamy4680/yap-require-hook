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
    return exports.add-reference m, request



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
    idx = loaded-modules |> find-index (.module == m)
    return null unless idx?
    {name} = loaded-modules[idx]
    return name: name, basename: path.basename name

  add-reference: (m, name) ->
    {loaded-modules} = module
    lm = module: m, name: name
    loaded-modules.push lm
    return m
