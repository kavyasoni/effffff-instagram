$(window).scroll(function() {
  var scroll = $(window).scrollTop();

  if (scroll > 10) {
    $(".top-nav").addClass("top-nav-border");
  } else {
    $(".top-nav").removeClass("top-nav-border");
  }
});