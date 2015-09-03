main = require '../lib/break-time'

describe 'Break Time', ->

  beforeEach ->
    atom.config.set('break-time.intervalcount', 3)
    atom.config.set('break-time.microinterval', 1)
    atom.config.set('break-time.break', 3)
    jasmine.attachToDOM(atom.views.getView(atom.workspace))
    main.activate()

  afterEach ->
    main.deactivate()

  describe 'On keypress', ->

    beforeEach ->
      document.onkeypress()

    it 'increments the interval counter', ->
      expect(main.currentInterval).toBe 1

    it 'displays the new interval count in status bar', ->
      expect(main.statusElement.num.innerText).toBe '1'

    it 'resets the key press event for the duration of the interval', ->
      expect(document.onkeypress).toBe null

  describe 'On last interval', ->
    spy = null

    beforeEach ->
      spy = spyOn(atom.notifications, 'addWarning')
      main.start()
      main.start()
      main.start()

    it 'shows a notification', ->
      expect(spy).toHaveBeenCalled()

    it 'displays the new interval count in status bar', ->
      expect(main.statusElement.num.innerText).toBe '3'

  describe 'After last interval', ->

    beforeEach ->
      main.start()
      main.start()
      main.start()
      main.start()

    it 'shows the break pane', ->
      expect(main.modalPanel.isVisible()).toBe true

    it 'shows "Break!" in status bar', ->
      expect(main.statusElement.num.innerText).toBe ''

  describe 'During break', ->

    beforeEach ->
      main.break()

    describe 'after each minute', ->

      beforeEach ->
        main.breakTimeView.update(1)
        main.breakTimeView.update(1)

      it 'updates the progress bar', ->
        expect(main.breakTimeView.v.value).toBe '2'

    describe 'after last minute', ->

      beforeEach ->
        main.unbreak()

      it 'hides the pane', ->
        expect(main.modalPanel.isVisible()).toBe false

      it 'resets the interval counter', ->
        expect(main.currentInterval).toBe 0

      it 'resets the status bar', ->
        expect(main.statusElement.num.innerText).toBe '0'
