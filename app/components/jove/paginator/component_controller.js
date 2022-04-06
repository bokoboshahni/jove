import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['sizer']

  resize() {
    this.sizerTarget.requestSubmit();
  }
}
