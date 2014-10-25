{CompositeDisposable} = require 'event-kit'

class OvertypeMode
  # Internal: The activation state of the minimap package.
  active: false
  # list of keyboard events to follow
  observers: []

  activate: (state) ->
    # Register toggle command
    atom.workspaceView.command 'overtype-mode:toggle', => @toggle()

  toggle: ->
    @active = !@active
    if @active
      # observe text insert of current text editor, and add this observer to observers list
      @observers.push atom.workspace.getActiveTextEditor().onWillInsertText (event) ->
        editor = atom.workspace.getActiveTextEditor()
        editor.delete() unless editor.getLastCursor().isAtEndOfLine()
    else
      # stop observing text insert events
      for observer in @observers
        observer.dispose()
      @observers = []


module.exports = new OvertypeMode
