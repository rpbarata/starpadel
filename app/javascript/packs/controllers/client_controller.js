import { Controller } from "stimulus";

export default class extends Controller {
  static get targets() {
    return ["output"];
  }

  readURL(event) {
    const input = event.currentTarget;
    const output = this.outputTarget;

    if (input.files && input.files[0]) {
      const reader = new FileReader();

      reader.onload = () => {
        output.src = reader.result;
      };

      reader.readAsDataURL(input.files[0]);
    }
  }
}
