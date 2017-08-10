{$} = require "atom"
{CompositeDisposable} = require 'atom'


class OvertypeMode
  active: false
  command: null
  className: 'overtype-cursor'
  editorCallbacks: null

  activate: (state) ->
    @command = atom.commands.add 'atom-text-editor', 'overtype-mode:toggle', => @toggle()
    @events = new CompositeDisposable
    @events.add atom.workspace.observeTextEditors (editor) =>
      @prepareEditor(editor)

  deactivate: ->
    @disable()
    @events.dispose()
    @command.dispose()
    @command = null

  toggle: ->
    if !@active
      @enable()
    else
      @disable()

  enable: ->
    @active = true
    @updateCursorStyle()

  disable: ->
    @active = false
    @updateCursorStyle()

  updateCursorStyle: ->
    for editor in atom.workspace.getTextEditors()
      view = atom.views.getView(editor)
      view.classList.add(@className) if @active
      view.classList.remove(@className) if !@active

  prepareEditor: (editor) ->
    @updateCursorStyle()
    @events.add editor.onWillInsertText (text) => @onType(editor)

  onType: (editor) ->
    return unless @active
    # Only trigger when user types manually
    return unless window.event instanceof TextEvent

    for selection in editor.getSelections()
      continue if selection.isEmpty() && selection.cursor.isAtEndOfLine()
      if selection.isEmpty()
        selection.selectRight()

module.exports = new OvertypeMode
