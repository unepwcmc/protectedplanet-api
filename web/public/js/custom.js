document.addEventListener('DOMContentLoaded', function() {
  var accordions = document.querySelectorAll('.js-accordion');

  accordions.forEach(function(accordionEl) {
    var switchEl = accordionEl.querySelector('.js-switch');
    var targetEls = accordionEl.querySelectorAll('.js-target');

    accordionEl.querySelectorAll('.js-trigger').forEach(function(triggerEl) {
      triggerEl.addEventListener('click', function(ev) {
        ev.preventDefault();

        if (switchEl) {
          switchEl.classList.toggle('is-open');
          switchEl.classList.toggle('is-closed');
          triggerEl.setAttribute('aria-expanded', switchEl.classList.contains('is-open') ? 'true' : 'false');
        }

        targetEls.forEach(function(targetEl) {
          targetEl.classList.toggle('u-hide');
        });
      });
    });
  });

  document.querySelectorAll('.js-dismissable').forEach(function(dismissableEl) {
    var targetEls = dismissableEl.querySelectorAll('.js-target');
    if (dismissableEl.classList.contains('js-target')) {
      targetEls = Array.prototype.slice.call(targetEls).concat([dismissableEl]);
    }

    dismissableEl.querySelectorAll('.js-trigger').forEach(function(triggerEl) {
      triggerEl.addEventListener('click', function(ev) {
        ev.preventDefault();
        targetEls.forEach(function(targetEl) {
          targetEl.classList.add('u-hide');
        });
      });
    });
  });

  document.querySelectorAll('.js-licence-select').forEach(function(selectEl) {
    selectEl.addEventListener('change', function() {
      var isVisible = selectEl.value === 'Yes';
      document.querySelectorAll('.js-licence-input').forEach(function(inputEl) {
        inputEl.classList.toggle('u-hide', !isVisible);
      });
    });
  });

  document.querySelectorAll('.js-confirm-delete').forEach(function(buttonEl) {
    buttonEl.addEventListener('click', function(ev) {
      if (!window.confirm('Are you sure?')) {
        ev.preventDefault();
      }
    });
  });
});
