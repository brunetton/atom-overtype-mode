{$} = require "atom"
{CompositeDisposable} = require 'atom'


class OvertypeMode
  active: false
  command: null
  className: 'overtype-cursor'
  willInsertText: null
  didChangeVisibility: null

  activate: (state) ->
    @command = atom.commands.add 'atom-text-editor', 'overtype-mode:toggle', => @toggle()
    @willInsertText = new CompositeDisposable
    @didChangeVisibility = new CompositeDisposable

  deactivate: ->
    @disable()
    @willInsertText = null
    @didChangeVisibility = null
    @command.dispose()
    @command = null

  toggle: ->
    if !@active
      @enable()
    else
      @disable()

  enable: ->
    atom.workspace.observeTextEditors (editor) =>
      atom.views.getView(editor).classList.add(@className)
      @willInsertText.add editor.onWillInsertText (text) =>
        editor.delete() unless editor.getLastCursor().isAtEndOfLine()
      @didChangeVisibility.add editor.getLastCursor().onDidChangeVisibility (visibility) =>
        atom.views.getView(editor).classList.add(@className)
    @active = true

  disable: ->
    atom.workspace.observeTextEditors (editor) =>
      atom.views.getView(editor).classList.remove(@className)
    @willInsertText.dispose()
    @didChangeVisibility.dispose()
    @active = false

module.exports = new OvertypeMode
