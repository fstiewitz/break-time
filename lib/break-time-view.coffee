module.exports =
  class BreakTimeView

    constructor: ->
      @element = document.createElement 'div'
      @message = document.createElement 'ul'
      @line = document.createElement 'div'
      @progressbar = document.createElement 'progress'

      @m = document.createAttribute 'max'
      @v = document.createAttribute 'value'

      @message.classList.add 'break-time-message'
      @message.classList.add 'background-message'
      @element.classList.add 'break-time-view'

      @m.value = atom.config.get('break-time.break')
      @v.value = 0

      @progressbar.attributes.setNamedItem @m
      @progressbar.attributes.setNamedItem @v

      @line.innerHTML = '<span class="text-highlight">Time to take a <span class="text-error">break</span>.</span>'

      @message.appendChild @line
      @message.appendChild @progressbar
      @element.appendChild @message

    update: (v) ->
      @v.value = parseInt(@v.value) + v

    reset: ->
      @v.value = 0
      @m.value = atom.config.get('break-time.break')

    getElement: ->
      @element
