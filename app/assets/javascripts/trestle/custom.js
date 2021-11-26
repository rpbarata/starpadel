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

  $('#lessons_type_is_pack').click(function(e){
    if (e.currentTarget.checked) {
      $('#number_of_lessons_row')[0].style.visibility = "visible";
    } else {
      $('#number_of_lessons_row')[0].style.visibility = "hidden";
      $('#lessons_type_number_of_lessons')[0].value = "";
    }
  })
})