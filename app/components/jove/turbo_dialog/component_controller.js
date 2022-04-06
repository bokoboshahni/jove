import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['modal']

  close() {
    this.element.parentElement.removeAttribute("src") // it might be nice to also remove the modal SRC
    this.element.remove()
  }

  submitEnd(e) {
    if (e.detail.success) {
      this.close()
    }
  }

  closeKeyboard(e) {
    if (e.code == 'Escape') {
      this.close()
    }
  }

  closeBackground(e) {
    if (e && this.modalTarget.contains(e.target)) {
      return
    }
    this.close()
  }
}
