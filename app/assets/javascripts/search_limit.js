$(document).ready(function() {
  var $limitDiv = $('#daily-limit-explanation');

  $('#daily-limit-chevron-btn').on('click', function() {
    $limitDiv.show();
    $(this).hide();
  });
});