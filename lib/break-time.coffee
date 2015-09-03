BreakTimeView = require './break-time-view'
StatusElement = require './status-element'

module.exports = BreakTime =
  breakTimeView: null
  modalPanel: null

  activate: ->
    @breakTimeView = new BreakTimeView
    @statusElement = new StatusElement
    @modalPanel = atom.workspace.addModalPanel(item: @breakTimeView.getElement(), visible: false)

    @modalPanel._hide = @modalPanel.hide
    @modalPanel.hide = ->

    element = @modalPanel.getItem()

    element.parentNode.style.left = '0px'
    element.parentNode.style.padding = '0'
    element.parentNode.style.margin = '0'
    element.parentNode.style.width = '100%'
    element.parentNode.style.height = '100%'
    element.parentNode.style.opacity = '0.85'

    @currentInterval = 0
    @statusElement.reset()

    @save_command = atom.commands.dispatch
    @save_keymaps = atom.keymaps.handleKeyboardEvent
    @save_keypress = document.onkeypress
    document.onkeypress = => @start()

  deactivate: ->
    @statusTile?.destroy()
    @statusElement = null
    @statusTile = null
    @modalPanel.destroy()
    @modalPanel = null
    @breakTimeView = null
    document.onkeypress = @save_keypress
    atom.commands.dispatch = @save_command
    atom.keymaps.handleKeyboardEvent = @save_keymaps

  start: ->
    return @break() if @currentInterval++ is atom.config.get('break-time.intervalcount')
    atom.notifications?.addInfo "You will take a break in #{atom.config.get('break-time.microinterval')} minutes" if @currentInterval + 1 is atom.config.get('break-time.intervalcount')
    @statusElement.update(1)
    document.onkeypress = null
    clearTimeout(@next)
    @next = setTimeout( =>
      document.onkeypress = => @start()
      @break() if @currentInterval + 1 is atom.config.get('break-time.intervalcount')
    , atom.config.get('break-time.microinterval') * 60 * 1000)

  break: ->
    clearTimeout(@next)
    document.onkeypress = @save_keypress

    @statusElement.break()

    @breakTimeView.reset()
    @modalPanel.show()

    @breaker = setInterval( =>
      @breakTimeView.update(1)
      if @breakTimeView.v.value >= atom.config.get('break-time.break')
        clearInterval(@breaker)
        @unbreak()
    , 60 * 1000)

    atom.commands.dispatch = ->
    atom.keymaps.handleKeyboardEvent = ->
    document.onkeypress = -> false

  unbreak: ->
    @modalPanel._hide()
    @statusElement.reset()
    @currentInterval = 0
    document.onkeypress = => @start()
    atom.commands.dispatch = @save_command
    atom.keymaps.handleKeyboardEvent = @save_keymaps

  consumeStatusBar: (statusBar) ->
    @statusTile = statusBar.addRightTile(item: @statusElement.getElement(), priority: 100)

  config:
    intervalcount:
      title: 'Interval Count'
      description: 'Number of micro intervals before break time'
      default: 4
      type: 'integer'
    microinterval:
      title: 'Micro Interval'
      description: 'Minutes in one micro interval'
      default: 13
      type: 'integer'
    break:
      title: 'Break length'
      description: 'Break time in minutes'
      default: 17
      type: 'integer'