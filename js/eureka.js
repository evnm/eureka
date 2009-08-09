Event.observe('generate_button', 'click', displayLoadingMessage);

function displayLoadingMessage() {
  Element.show($('loading_message'));
}