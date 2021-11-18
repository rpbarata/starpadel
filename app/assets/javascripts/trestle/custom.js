// This file may be used for providing additional customizations to the Trestle
// admin. It will be automatically included within all admin pages.
//
// For organizational purposes, you may wish to define your customizations
// within individual partials and `require` them here.
//
//  e.g. //= require "trestle/custom/my_custom_js"

//= require chartkick
//= require Chart.bundle

document.addEventListener('turbolinks:load', () => {
  $('#client_member_id').on('input', function (e) {
    if (e.currentTarget.value.length > 0) {
      $('#client_is_master_member').attr('disabled', false);
    } else {
      $('#client_is_master_member').attr('disabled', true);
      $('#client_is_master_member')[0].checked = false
    }
  });
})