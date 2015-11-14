{$} = require "atom"
{CompositeDisposable} = require 'atom'


class OvertypeMode
  active: false
  command: null
  className: 'overtype-cursor'
  editorCallbacks: null

  activate: (state) ->
    @command = atom.commands.add 'atom-text-editor', 'overtype-mode:toggle', => @toggle()

  deactivate: ->
    @disable()
    @command.dispose()
    @command = null

  toggle: ->
    if !@active
      @enable()
    else
      @disable()

  enable: ->
    @editorCallbacks = new CompositeDisposable
    atom.workspace.observeTextEditors (editor) =>
      atom.views.getView(editor).classList.add(@className)
      @editorCallbacks.add editor.onWillInsertText (text) => @onType(editor)
      @editorCallbacks.add editor.onDidInsertText (text) => @onAfterType(editor)
      @editorCallbacks.add editor.getLastCursor().onDidChangeVisibility (visibility) =>
        atom.views.getView(editor).classList.add(@className)
    @active = true

  disable: ->
    atom.workspace.observeTextEditors (editor) =>
      atom.views.getView(editor).classList.remove(@className)
    @editorCallbacks.dispose()
    @active = false

  onType: (editor) ->
    return if editor.getLastCursor().isAtEndOfLine()
    # Only trigger when user types manually
    return unless window.event instanceof TextEvent
    editor.delete()

  onAfterType: (editor) ->
    return unless window.event instanceof TextEvent

module.exports = new OvertypeMode
