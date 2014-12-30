{$} = require "atom"

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
      textEditor = atom.workspace.getActiveTextEditor()
      @observers.push textEditor.onWillInsertText (event) ->
        editor = atom.workspace.getActiveTextEditor()
        if ! editor.getLastCursor().isAtEndOfLine()
          textEditor = atom.workspace.getActiveTextEditor()
          textBuffer = textEditor.getBuffer()
          cursorPosition = textEditor.getCursorBufferPosition()
          line = cursorPosition.row
          column = cursorPosition.column
          text = event.text

          console.log('text to insert:', text, text.length)
          #bbbuffer###############""
          # Replace  ##########""
          # Replace text in buffer
          textBuffer.setTextInRange([[line, column], [line, column + text.length]], text)
          # a2345
          # move cursor to the end of the inserted text

          textEditor.moveCursorRight(text.length)
          # Cancel event; ie disable future insertion of that text
          event.cancel()

        # Delete next character
        # editor.delete() unless editor.getLastCursor().isAtEndOfLine()
      # change cursor visual
      atom.workspaceView.getActiveView().find(".cursor").addClass('overtype-cursor')
      # observe cursor visibility change (typically when moving from insert to select mode)
      @observers.push textEditor.getLastCursor().onDidChangeVisibility (visibility) ->
        # change cursor visual
        atom.workspaceView.getActiveView().find(".cursor").addClass('overtype-cursor')
    else
      # stop observing text insert events
      for observer in @observers
        observer.dispose()
      @observers = []
      # remove cursor visual
      atom.workspaceView.getActiveView().find(".cursor").removeClass('overtype-cursor')


module.exports = new OvertypeMode
