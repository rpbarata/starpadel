import { Controller } from "stimulus";
import Cookies from 'js-cookie';

export default class extends Controller {
  accept() {
    var isSecure = location.protocol === 'https:';
    Cookies.set('cookie_consented', true, { path: '/', expires: 365, secure: isSecure });

    var container = document.querySelector('.js-cookies');
    container.parentNode.removeChild(container);
  }
}
