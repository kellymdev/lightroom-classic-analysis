$(document).ready(function() {
  $('.menu').on('click', 'li', function(e) {
    e.preventDefault();
    var clickedLinkClass = $(this).attr('class');
    switchSectionContent(clickedLinkClass);
  });
});

function switchSectionContent(clickedLinkClass) {
  var sectionToDisplay = clickedLinkClass.replace('-link', '');
  hideAllSections();
  enableSection(sectionToDisplay);
}

function hideAllSections() {
  $('.content-section').hide();
}

function enableSection(sectionToDisplay) {
  $('.' + sectionToDisplay).show();
}