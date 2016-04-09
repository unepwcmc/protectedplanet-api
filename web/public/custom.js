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
});
