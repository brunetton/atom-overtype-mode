'use babel';
import {CompositeDisposable} from "atom";

export class OvertypeMode {
  constructor() {
    this.active = false;
    this.command = null;
    this.className = 'overtype-cursor';
    this.editorCallbacks = null;
  }

  activate() {
    this.command = atom.commands.add('atom-text-editor', 'overtype-mode:toggle', () => this.toggle());
    this.events = new CompositeDisposable();
    this.events.add(atom.workspace.observeTextEditors((editor) => this.prepareEditor(editor)));
  }

  deactivate() {
    this.disable();
    this.events.dispose();
    this.command.dispose();
    this.command = null;
  }

  toggle() {
    if (!this.active) {
      this.enable();
    } else {
      this.disable();
    }
  }

  enable() {
    this.active = true;
    this.updateCursorStyle();
  }

  disable() {
    this.active = false;
    this.updateCursorStyle();
  }

  updateCursorStyle() {
    for (const editor of atom.workspace.getTextEditors()) {
      const view = atom.views.getView(editor);
      if (this.active) {
        view.classList.add(this.className);
      } else {
        view.classList.remove(this.className);
      }
    }
  }

  prepareEditor(editor) {
    this.updateCursorStyle()
    this.events.add(editor.onWillInsertText((text) => this.onType(editor)));
    this.events.add(editor.getLastCursor().onDidChangeVisibility(
      (visibility) => this.updateCursorStyle()
    ));
  }

  onType(editor) {
    if (!this.active) return;

    // Only trigger when user types manually
    if (!(window.event instanceof TextEvent)) return;

    for (const selection of editor.getSelections()) {
      if (!selection.isEmpty()) continue;
      if (selection.cursor.isAtEndOfLine()) continue;

      selection.selectRight()
    }
  }
}
