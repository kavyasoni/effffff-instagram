$(document).ready(function() {
  var currentInstruction = 1;

  var $instructionOne = $('#oic-1'),
      $instructionTwo = $('#oic-2'),
      $instructionThree = $('#oic-3'),
      $prevButton = $('#onboarding-prev'),
      $nextButton = $('#onboarding-next'),
      $counter = $('#oic-slide');

  function updateInstructionCounter() {
    $($counter).html(currentInstruction);
  }

  function hidePreviousButton() {
    $prevButton.hide();
  }

  function showPreviousButton() {
    $prevButton.show();
  }

  function hideNextButton() {
    $nextButton.hide();
  }

  function showNextButton() {
    $nextButton.show();
  }

  function hideConfirmButton() {
    $('#oic-form').removeClass('oic-form');
    $('#oic-form').addClass('oic-form-hidden');
  }

  function showConfirmButton() {
    $('#oic-form').removeClass('oic-form-hidden');
    $('#oic-form').addClass('oic-form');
  }

  updateInstructionCounter();
  hidePreviousButton();

  $($prevButton).click(function() {
    $('#oic-' + currentInstruction).hide();
    currentInstruction -= 1;
    $('#oic-' + currentInstruction).show();
    showNextButton();
    updateInstructionCounter();

    if (currentInstruction === 1) {
      hidePreviousButton();
    }

    if (currentInstruction === 2) {
      hideConfirmButton();
    }
  });

  $($nextButton).click(function() {
    $('#oic-' + currentInstruction).hide();
    currentInstruction += 1;
    $('#oic-' + currentInstruction).show();
    showPreviousButton();
    updateInstructionCounter();

    if (currentInstruction === 3) {
      showConfirmButton();
      hideNextButton();
    }
  });
});