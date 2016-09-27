$(document).ready(function() {
  var accordions = $('.js-accordion');

  var enableToggling = function($accordionEl) {
    var $switchEl = $accordionEl.find(".js-switch");
    var $targetEl = $accordionEl.find(".js-target");

    $accordionEl.find(".js-trigger").click(function(ev) {
      $switchEl.toggleClass('is-open is-closed');
      $targetEl.toggleClass('u-hide');
    });
  };

  accordions.each(function(i, accordionEl) {
    enableToggling($(accordionEl));
  });

  var dismissables = $(".js-dismissable");

  var dismissOnClick = function($dismissableEl) {
    var $targetEl = $dismissableEl.find(".js-target").addBack(".js-target");

    $dismissableEl.find(".js-trigger").click(function(ev) {
      $targetEl.addClass("u-hide");
      ev.preventDefault();
    });
  };

  dismissables.each(function(i, dismissableEl) {
    dismissOnClick($(dismissableEl));
  });
});
