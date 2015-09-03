module.exports =
  class StatusElement
    constructor: ->
      @element = document.createElement 'div'
      @element.classList.add 'inline-block'
      @block = document.createElement 'div'
      @block.classList.add 'icon'
      @num = document.createElement 'span'
      @info = document.createElement 'span'
      @block.appendChild @num
      @block.appendChild @info
      @element.appendChild @block

    getElement: ->
      @element

    reset: ->
      @block.classList.remove 'icon-bell'
      @block.classList.add 'icon-watch'
      @num.innerText = '0'
      count = atom.config.get('break-time.intervalcount')
      length = atom.config.get('break-time.microinterval')
      sum = count * length
      @info.innerText = "/#{count}@#{length} min = #{sum} min"

    update: (v) ->
      @num.innerText = parseInt(@num.innerText) + v
      if parseInt(@num.innerText) + 1 is atom.config.get('break-time.intervalcount')
        @block.classList.remove 'icon-watch'
        @block.classList.add 'icon-bell'

    break: ->
      @num.innerText = ''
      @info.innerHTML = "<span class='text-error'>Break! #{atom.config.get('break-time.break')} min</span>"
