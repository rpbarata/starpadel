import { Controller } from "stimulus";

export default class extends Controller {
  openHref(event) {
    window.location.href = event.currentTarget.dataset.href;
  }
}
