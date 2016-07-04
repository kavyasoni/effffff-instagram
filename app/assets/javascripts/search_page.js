$( document ).ready(function() {
  var $tagOne = $('#hashtag_one'),
      $tagTwo = $('#hashtag_two'),
      $tagThree = $('#hashtag_three'),
      $warning = $('#ht-warning'),
      $ETwarning = $('#empty-tags-warning'),
      $DTwarning = $('#duplicate-tags-warning'),
      $ISTwarning = $('#illegal-string-tags-warning'),
      pressedSearch = false,
      duplicateHashtagsDetected = false;

  function onlyUnique(value, index, self) {
    return self.indexOf(value) === index;
  }

  function updateDetectedDupes(tagsArray, uniqueTagsArray) {
    if (tagsArray.length < 3) {
      duplicateHashtagsDetected = false;
    } else {
      if (uniqueTagsArray.length === 3) {
        duplicateHashtagsDetected = false;
      } else {
        duplicateHashtagsDetected = true;
      }
    }
  }

  function displayDuplicationWarning() {
    $warning.removeClass('hidden');
    $DTwarning.removeClass('hidden');
  }

  function hideDuplicationWarning() {
    $warning.addClass('hidden');
    $DTwarning.addClass('hidden');
  }

  function stripOfHashtagSymbol(tag) {
    if (tag[0] === '#') {
      var stripped = tag.substring(1)
      return stripped;
    } else {
      return tag;
    }
  }

  function checkForDuplicates() {
    var tags = [];

    [$tagOne, $tagTwo, $tagThree].forEach(function(input_field) {
      var value = input_field.val();
      if (value.length > 0) {
        checkedValue = stripOfHashtagSymbol(value)
        tags.push(checkedValue);
      }
    });

    var uniqueTags = tags.filter(onlyUnique);
    updateDetectedDupes(tags, uniqueTags);

    if (duplicateHashtagsDetected === true) {
      displayDuplicationWarning();
    } else {
      hideDuplicationWarning();
    }
  }

  function displayWarnings() {
    var warnings = [];
    var illegalStringWarnings = [];

    $('#hashtag_one, #hashtag_two, #hashtag_three').each(function() {
      if ($(this).hasClass('input-warning')) {
        $warning.removeClass('hidden');

        if ($(this).val().length === 0) {
          warnings.push($(this).val());
        } else {
          illegalStringWarnings.push($(this).val());
        }
      } else {
        $warning.addClass('hidden');
      }
    });

    if (illegalStringWarnings.length > 0) {
      $ISTwarning.removeClass('hidden');
    } else {
      $ISTwarning.addClass('hidden');
    }

    if (warnings.length > 0) {
      $ETwarning.removeClass('hidden');
    } else {
      $ETwarning.addClass('hidden');
    }

    return warnings;
  }

  function checkFieldsForValues() {
    [$tagOne, $tagTwo, $tagThree].forEach(function(input_field) {
      var cleaned_input = input_field.val().replace(/ /g, '');

      if (cleaned_input.length === 0) {
        input_field.addClass('input-warning');
      } else if (cleaned_input.indexOf(' ') > 0) {
        input_field.addClass('input-warning');
      } else {
        input_field.removeClass('input-warning');
      }
    });
  }

  $('#search-btn').on('click', function(event) {
    pressedSearch = true;
    checkFieldsForValues();
    var warnings = displayWarnings();

    if (warnings.length > 0) {
      event.preventDefault();
    }

    if (duplicateHashtagsDetected === true) {
      displayDuplicationWarning();
      event.preventDefault();
    }
  });

  $(document).on('blur', '#hashtag_one, #hashtag_two, #hashtag_three', function() {
    checkForDuplicates();

    if (pressedSearch === true) {
      checkFieldsForValues();
      displayWarnings();
    }
  });
});