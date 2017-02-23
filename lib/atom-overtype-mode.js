'use babel';
import {OvertypeMode} from './OvertypeMode';

export default {
  overtypeMode: null,

  activate() {
    this.overtypeMode = new OvertypeMode();
    this.overtypeMode.activate();
  },

  deactivate() {
    if (this.overtypeMode) {
      this.overtypeMode.deactivate();
      this.overtypeMode = null;
    }
  }
}
