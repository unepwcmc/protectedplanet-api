$(document).ready(function() {
  var expandableSections = $('.js-expandable-section');

  var enableToggling = function($sectionEl) {
    var $switchEl = $sectionEl.find(".js-switch");
    var $targetEl = $sectionEl.find(".js-target");

    $sectionEl.find(".js-trigger").click(function(ev) {
      $switchEl.toggleClass('is-open is-closed');
      $targetEl.toggleClass('u-hide');
    });
  };

  expandableSections.each(function(i, sectionEl) {
    enableToggling($(sectionEl));
  });
});
