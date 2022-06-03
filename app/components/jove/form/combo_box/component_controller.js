import { Autocomplete } from 'stimulus-autocomplete';

export default class extends Autocomplete {
  static targets = ["input", "hidden", "menu", "results"]

  open() {
    if (this.menuShown) return

    this.menuShown = true
    this.element.setAttribute("aria-expanded", "true")
    this.element.dispatchEvent(
      new CustomEvent("toggle", {
        detail: { action: "open", inputTarget: this.inputTarget, menuTarget: this.menuTarget, resultsTarget: this.resultsTarget }
      })
    )
  }

  close() {
    if (!this.menuShown) return

    this.menuShown = false
    this.inputTarget.removeAttribute("aria-activedescendant")
    this.element.setAttribute("aria-expanded", "false")
    this.element.dispatchEvent(
      new CustomEvent("toggle", {
        detail: { action: "close", inputTarget: this.inputTarget, menuTarget: this.menuTarget, resultsTarget: this.resultsTarget }
      })
    )
  }

  hideAndRemoveOptions() {
    this.close()
  }

  get menuShown() {
    return !this.menuTarget.hidden
  }

  set menuShown(value) {
    this.menuTarget.hidden = !value
  }
}
