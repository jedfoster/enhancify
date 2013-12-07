(($) ->
  $.fn.accordionify = (options) ->
    return @each ->
      element = $(this)
      return new AccordionForm(element, options) unless element.data('accordionForm')

  class AccordionForm
    constructor: (@_element, options) ->
      @_options = $.extend(
          stepSelector: '.accordion-step',
          headerSelector: '.accordion-header',
          editButtonClass: 'accordion-edit',
          continueButtonClass: 'accordion-continue'
          isStepComplete: (element) -> true
          onCollapse: (element) ->,
          onExpand: (element) ->,
        ,
        options)

      stepElements = @_element.find(@_options.stepSelector)
      @_steps = stepElements.map (index, element) =>
        new AccordionStep(this, index, (index == stepElements.length-1), $(element), @_options)

      @_transitionTo(0)
      @_collapseSubsequentSteps()

    continue: ->
      if @_currentStep.isComplete() and !@_currentStep.isLast
        @_transitionTo(@_currentStep.index+1)
        return true
      return false

    goBackTo: (index) ->
      return if index < 0 or index >= @_currentStep.index
      @_transitionTo(index)    
      @_collapseSubsequentSteps()

    _transitionTo: (index) ->
      if @_currentStep? then @_currentStep.collapse(true)
      @_currentStep = @_steps[index]
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

    expand: ->
      $('html, body').animate( { scrollTop: @_element.offset().top } );
      @_header.find('button.' + @_options.editButtonClass).hide()
      @_header.siblings().slideDown(500)
      @_options.onExpand(@_element[0])

    collapse: (showEditButton) ->
      editButton = @_header.find('button.' + @_options.editButtonClass)
      if (showEditButton) then editButton.show() else editButton.hide()
      @_header.siblings().hide()
      @_options.onCollapse(@_element[0])

    isComplete: ->
      return @_options.isStepComplete(@_element)

    _appendEditButton: ->
      button = $('<button type="button">Edit</button>')
      button.addClass(@_options.editButtonClass)
      button.hide()
      button.click => @_accordionForm.goBackTo(@index)
      @_header.append(button)

    _appendContinueButton: ->
      button = $('<button type="button">Continue</button>')
      button.addClass(@_options.continueButtonClass)
      button.click => @_accordionForm.continue()
      @_element.append(button)

)(jQuery)