(($) ->
  $.fn.accordionify = (options) ->
    element = $(this[0])
    if (!element.data('accordionForm'))
      element.data('accordionForm', new AccordionForm(element, options))
    return element.data('accordionForm')

  class AccordionForm
    constructor: (@_element, options) ->
      @_options = $.extend(
          stepSelector: '.accordion-step',
          headerSelector: '.accordion-header',
          editButtonClass: 'accordion-edit',
          continueButtonClass: 'accordion-continue',
          getEditButtonText: (element) -> "Edit",
          getContinueButtonText: (element) -> "Continue",
          isStepComplete: (element) -> true,
          onStepCollapsed: (element) ->,
          onStepExpanded: (element) ->,
          onStepDisabled: (element) ->,
          onStepEnabled: (element) ->,
        ,
        options)

      stepElements = @_element.find(@_options.stepSelector)
      @_steps = stepElements.map (index, element) =>
        new AccordionStep(this, index, (index == stepElements.length-1), $(element), @_options)

      @_transitionTo(@_steps[0])
      @_collapseSubsequentSteps()

    continue: ->
      if @_currentStep.isComplete() and !@_currentStep.isLast
        @_transitionTo(@_nextEnabledStep())

    goBackToStep: (index) ->
      targetStep = @_steps[index]
      if targetStep? and targetStep.isEnabled and index < @_currentStep.index
        @_transitionTo(targetStep)    
        @_collapseSubsequentSteps()

    disableStep: (index) ->
      targetStep = @_steps[index]
      if targetStep?
        targetStep.disable()
        if targetStep == @_currentStep then @continue()

    enableStep: (index) ->
      targetStep = @_steps[index]
      if targetStep?
        targetStep.enable()
        if index < @_currentStep.index then @goBackToStep(index)

    _nextEnabledStep: ->
      for step in @_steps.slice(@_currentStep.index+1)
        if step.isEnabled then return step

    _transitionTo: (targetStep) ->
      if @_currentStep? then @_currentStep.collapse(@_currentStep.isEnabled)
      @_currentStep = targetStep
      @_currentStep.expand()

    _collapseSubsequentSteps: ->
      for step in @_steps.slice(@_currentStep.index+1) 
        step.collapse(false)

  class AccordionStep
    constructor: (@_accordionForm, @index, @isLast, @_element, @_options) ->
      @_header = @_element.find(@_options.headerSelector)
      unless @isLast
        @_appendEditButton()
        @_appendContinueButton()
      @isEnabled = true

    expand: ->
      $('html, body').animate( { scrollTop: @_element.offset().top } );
      if !@isLast then @_editButton.hide()
      @_header.siblings().slideDown(500)
      @_options.onStepExpanded(@_element)

    collapse: (showEditButton) ->
      if !@isLast then @_editButton.toggle(showEditButton)
      @_header.siblings().hide()
      @_options.onStepCollapsed(@_element)

    isComplete: ->
      return @_options.isStepComplete(@_element)

    disable: ->
      if @isEnabled
        @isEnabled = false
        @_editButton.hide()
        @_continueButton.hide()
        @_options.onStepDisabled(@_element)

    enable:  ->
      if !@isEnabled
        @isEnabled = true
        @_options.onStepEnabled(@_element)

    _appendEditButton: ->
      @_editButton = $('<button type="button" class="' + @_options.editButtonClass + '">' +
        @_options.getEditButtonText(@_element) + '</button>')
      @_editButton.hide()
      @_editButton.click => @_accordionForm.goBackToStep(@index)
      @_header.append(@_editButton)

    _appendContinueButton: ->
      @_continueButton = $('<button type="button" class="' + @_options.continueButtonClass + '">' +
        @_options.getContinueButtonText(@_element) + '</button>')
      @_continueButton.click => @_accordionForm.continue()
      @_element.append(@_continueButton)
)(jQuery)